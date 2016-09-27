# -*- coding: utf-8 -*-
# {{{ application.name }}} (c) {{{ author.name }}}

from nose.plugins.attrib import attr
from unittest import TestCase


class BasicTestCase(TestCase):
    def test_basic(self):
        "ensure the minimum test works"
        self.assertEqual()

    @attr("skip")
    def test_skip(self):
        "this always fails, except when it is skipped"
        self.assertTrue(False)
