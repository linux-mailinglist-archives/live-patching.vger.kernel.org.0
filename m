Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0382A219AE
	for <lists+live-patching@lfdr.de>; Fri, 17 May 2019 16:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfEQORn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 May 2019 10:17:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:56332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729019AbfEQORm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 May 2019 10:17:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0BC4AD3A;
        Fri, 17 May 2019 14:17:41 +0000 (UTC)
Date:   Fri, 17 May 2019 16:17:40 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
cc:     jikos@kernel.org, joe.lawrence@redhat.com, jpoimboe@redhat.com,
        pmladek@suse.com, tglx@linutronix.de
Subject: livepatching selftests failure on current master branch
Message-ID: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

I noticed that livepatching selftests fail on our master branch 
(https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/).

...
TEST: busy target module ... not ok

--- expected
+++ result
@@ -7,16 +7,24 @@ livepatch: 'test_klp_callbacks_demo': in
 test_klp_callbacks_demo: pre_patch_callback: vmlinux
 test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
 livepatch: 'test_klp_callbacks_demo': starting patching transition
+livepatch: 'test_klp_callbacks_demo': completing patching transition
+test_klp_callbacks_demo: post_patch_callback: vmlinux
+test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
+livepatch: 'test_klp_callbacks_demo': patching complete
 % modprobe test_klp_callbacks_mod
 livepatch: applying patch 'test_klp_callbacks_demo' to loading module 
'test_klp_callbacks_mod'
 test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
+test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
 test_klp_callbacks_mod: test_klp_callbacks_mod_init
 % rmmod test_klp_callbacks_mod
 test_klp_callbacks_mod: test_klp_callbacks_mod_exit
+test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
 livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module 
'test_klp_callbacks_mod'
 test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
 % echo 0 > /sys/kernel/livepatch/test_klp_callbacks_demo/enabled
-livepatch: 'test_klp_callbacks_demo': reversing transition from patching to unpatching
+livepatch: 'test_klp_callbacks_demo': initializing unpatching transition
+test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
+test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
 livepatch: 'test_klp_callbacks_demo': starting unpatching transition
 livepatch: 'test_klp_callbacks_demo': completing unpatching transition
 test_klp_callbacks_demo: post_unpatch_callback: vmlinux

ERROR: livepatch kselftest(s) failed
not ok 1..2 selftests: livepatch: test-callbacks.sh [FAIL]

which probably means that the consistency model is not in the best shape. 
There were not many livepatch changes in the latest pull request. Stack 
unwinder changes may be connected, so adding Thomas to be aware if it 
leads in this direction.

Unfortunately, I'm leaving in a minute and will be gone till Wednesday, so 
if someone confirms and wants to investigate, definitely feel free to do 
it.

Miroslav
