module Ingesters
  class VerbnetClassIngester

    def ingest(data)
      verbnet_class(data['VNCLASS'])
    end

    private
    def selectional_restrictions(data)
      return nil if data.nil?

      sr = SelectionalRestriction.new(logic: data['logic'])
      if data['SELRESTR'].class == Array
        data['SELRESTR'].each do |s|
          sr.child_selectional_restrictions.build(value: s['Value'], type: s['type'])
        end
      else
        s = data['SELRESTR']
        sr.child_selectional_restrictions.build(value: s['Value'], type: s['type'])
      end

      if data['SELRESTRS']
        sr.child_selectional_restrictions << selectional_restrictions(data['SELRESTRS'])
      end
      sr
    end

    def thematic_role(data)
      tr = ThematicRole.new(name: data['type'])
      tr.selectional_restriction = selectional_restrictions(data['SELRESTRS'])
      tr
    end

    def description(data)
      Description.new(number: data['descriptionNumber'], primary: data['primary'], secondary: data['secondary'], xtag: data['xtag'])
    end

    def examples(data)
      [Example.new(text: data['EXAMPLE'])]
    end

    def np(data)
      n = NounPhrase.new
      n.selectional_restriction = selectional_restrictions(data['SELRESTRS'])
      n.value = data['value']
      n
    end

    def adj(data)
      Adjective.new
    end

    def adv(data)
      Adverb.new
    end

    def prep(data)
      p = Preposition.new
      p.selectional_restriction = selectional_restrictions(data['SELRESTRS'])
      p
    end

    def lex(data)
      Lex.new
    end

    def verb(data)
      Verb.new
    end

    def syntax(data)
      s = Syntax.new
      sus = []
      data['SU'].each do |su|
        sus << case su['type']
          when 'NP'
            np(su)
          when 'ADJ'
            adj(su)
          when 'ADV'
            adv(su)
          when 'PREP'
            prep(su)
          when 'LEX'
            lex(su)
          when 'VERB'
            verb(su)
        end

      end

      s.syntactic_units = sus
      s

    end

    def frame(data)
      f = Frame.new(name: data)
      f.description = description(data['DESCRIPTION'])
      f.examples = examples(data['EXAMPLES'])
      f.syntax = syntax(data['SYNTAX'])
      #f.semantics = semantics(data['SEMANTICS'])

      f
    end

    def verbnet_class(data, parent = nil)
      members = []

      puts data['ID']
      vnc = parent.nil? ? VerbnetClass.create(name: data['ID']) : parent.child_verbnet_classes.create(name: data['ID'])

      if data['MEMBERS']
        case data['MEMBERS']['MEMBER']
          when Array
            data['MEMBERS']['MEMBER'].each do |m|
              m['wordnet_keys'] = m['wn'].split
              m.delete('wn')

              members << Member.new(m)
            end
          when Hash
            m = data['MEMBERS']['MEMBER']
            m['wordnet_keys'] = m['wn'].split
            m.delete('wn')
            members << Member.new(m)
        end
      end

      if data['SUBCLASSES']
        if data['SUBCLASSES']['VNSUBCLASS'].class == Hash
          verbnet_class(data['SUBCLASSES']['VNSUBCLASS'], vnc)
        else
          data['SUBCLASSES']['VNSUBCLASS'].each do |sub|
            verbnet_class(sub, vnc)
          end
        end
      end

      thematic_roles = []
      if data['THEMROLES']
        if data['THEMROLES']['THEMROLE'].class == Array
          data['THEMROLES']['THEMROLE'].each do |themrole|
            thematic_roles << thematic_role(themrole)
          end
        else
          thematic_roles << thematic_role(data['THEMROLES']['THEMROLE'])
        end
      end

      frames = []
      if data['FRAMES']
        if data['FRAMES']['FRAME'].class == Array
          data['FRAMES']['FRAME'].each do |frame|
            frames << frame(frame)
          end
        else
          frames << frame(data['FRAMES']['FRAME'])
        end
      end

      vnc.frames = frames
      vnc.thematic_roles = thematic_roles
      vnc.members = members
      vnc.save

    end


  end
end