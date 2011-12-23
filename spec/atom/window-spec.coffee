require 'window'

describe "Window", ->
  describe "keybindings", ->
    beforeEach ->
      window.startup()

    afterEach ->
      window.shutdown()

    describe 'bindKey', ->
      it 'maps keypresses that match a pattern to an action', ->
        action1 = jasmine.createSpy 'action1'
        action2 = jasmine.createSpy 'action2'

        window.bindKey 'meta+1', action1
        window.bindKey 'meta+2', action2

        window.keydown 'meta+1'
        expect(action1).toHaveBeenCalled()
        expect(action2).not.toHaveBeenCalled()
        action1.reset()

        window.keydown 'meta+2'
        expect(action1).not.toHaveBeenCalled()
        expect(action2).toHaveBeenCalled()
        action2.reset()

        window.keydown 'meta+3'
        expect(action1).not.toHaveBeenCalled()
        expect(action2).not.toHaveBeenCalled()

    describe 'keyEventMatchesPattern', ->
      it 'returns true if the modifiers and letter in the pattern match the key event', ->
        expectMatch = (pattern) ->
          expect(window.keyEventMatchesPattern(window.createKeyEvent(pattern), pattern)).toBeTruthy()

        expectNoMatch = (eventPattern, patternToTest) ->
          event = window.createKeyEvent(eventPattern)
          expect(window.keyEventMatchesPattern(event, patternToTest)).toBeFalsy()

        expectMatch 'meta+a'
        expectMatch 'meta+1'
        expectMatch 'alt+1'
        expectMatch 'ctrl+1'
        expectMatch 'shift+1'
        expectMatch 'shift+a'
        expectMatch 'meta+alt+1'
        expectMatch 'meta+alt+ctrl+1'
        expectMatch 'meta+alt+ctrl+shift+1'

        expectNoMatch 'meta+alt+ctrl+shift+1', 'meta+1'
        expectNoMatch 'meta+1', 'meta+alt+1'
        expectNoMatch 'meta+a', 'meta+b'
        expectNoMatch 'meta+a', 'meta+b'
        expectNoMatch 'meta+1', 'alt+1'

    describe 'meta+s', ->
      it 'saves the buffer', ->
        spyOn(window.editor, 'save')
        window.keydown 'meta+s'
        expect(window.editor.save).toHaveBeenCalled()
