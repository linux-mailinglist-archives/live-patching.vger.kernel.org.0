Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB9CAB987
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2019 15:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393380AbfIFNoQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Fri, 6 Sep 2019 09:44:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:43354 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393382AbfIFNoQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Sep 2019 09:44:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 795E7B021;
        Fri,  6 Sep 2019 13:44:14 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     live-patching@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.cz>, Nicolai Stange <nstange@suse.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.de>,
        Alice Ferrazzi <alicef@gentoo.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
Subject: LPC19 Live Patching MC: materials for "Source-based livepatch creation tooling"
Date:   Fri, 06 Sep 2019 15:44:13 +0200
Message-ID: <87o8zxpmj6.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

to get the most out of the "Source-based livepatch creation tooling"
session at this year's LPC Live Patching MC, I'd like to spend as little
time as possible on (re-)introducing klp-ccp and the approch behind it,
but focus more on discussing open questions.

So, to give everybody a chance to get a good overview on past
discussions as well as the current state, let me share a few pointers.

First of all, there had been Miroslav's talk from last year about
compiler optimizations ([1]) and also mine, where I outlined an initial
approach to automating source based livepatch creation ([2]). Recordings
are available.

Meanwhile, the implementation of the proposed tool for copying&pasting
live patches together, klp-ccp, has progressed to a state where it can
actually be used (*).

The sources for klp-ccp have recently been published at ([3]). I've put
together a preliminary README describing the overall mode of operation
and its interface. The topics I'd like to bring up for discussion are
mostly related to integration, so it would be awesome if you could have
a brief look.

Finally, in case you'd like to get an idea of how the actual output from
klp-ccp would look like, you can find the results from three different
runs against more or less random function sets at [4], [5] and [6].

Wish you all a save journey and see you next week!

Nicolai


[1] https://linuxplumbersconf.org/event/2/contributions/177/
    (LPC18, GCC optimizations and their impacts on live patching")
[2] https://linuxplumbersconf.org/event/2/contributions/172/
    (Livepatch patch creation tooling")
[3] https://github.com/SUSE/klp-ccp
[4] https://beta.suse.com/private/nstange/klp-ccp-examples/lp-mm-gup.c
[5] https://beta.suse.com/private/nstange/klp-ccp-examples/lp-drivers-nvme-target-fc.c
[6] https://beta.suse.com/private/nstange/klp-ccp-examples/lp-arch-x86-kvm-vmx.c

(*) with caution

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 247165, AG München), GF: Felix Imendörffer
