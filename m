Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0944B1303C
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 16:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfECOah (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 10:30:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:45480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726720AbfECOah (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 10:30:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16A4EAEB0;
        Fri,  3 May 2019 14:30:36 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        live-patching@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: [PATCH 0/2] livepatch/docs: Convert livepatch documentation to the ReST format
Date:   Fri,  3 May 2019 16:30:22 +0200
Message-Id: <20190503143024.28358-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

This is the original Mauro's patch and my extra fixup as a clean
patchset.

I want to be sure that other livepatching maintainers are fine
with the changes ;-)


Mauro Carvalho Chehab (1):
  docs: livepatch: convert docs to ReST and rename to *.rst

Petr Mladek (1):
  docs/livepatch: Unify style of livepatch documentation in the ReST
    format

 Documentation/ABI/testing/sysfs-kernel-livepatch   |   2 +-
 .../livepatch/{callbacks.txt => callbacks.rst}     |  45 +--
 ...mulative-patches.txt => cumulative-patches.rst} |  14 +-
 Documentation/livepatch/index.rst                  |  21 ++
 .../livepatch/{livepatch.txt => livepatch.rst}     |  62 ++--
 ...module-elf-format.txt => module-elf-format.rst} | 353 +++++++++++----------
 .../livepatch/{shadow-vars.txt => shadow-vars.rst} |  65 ++--
 tools/objtool/Documentation/stack-validation.txt   |   2 +-
 8 files changed, 307 insertions(+), 257 deletions(-)
 rename Documentation/livepatch/{callbacks.txt => callbacks.rst} (87%)
 rename Documentation/livepatch/{cumulative-patches.txt => cumulative-patches.rst} (89%)
 create mode 100644 Documentation/livepatch/index.rst
 rename Documentation/livepatch/{livepatch.txt => livepatch.rst} (93%)
 rename Documentation/livepatch/{module-elf-format.txt => module-elf-format.rst} (55%)
 rename Documentation/livepatch/{shadow-vars.txt => shadow-vars.rst} (87%)

-- 
2.16.4

