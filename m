Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1060FD77E3
	for <lists+live-patching@lfdr.de>; Tue, 15 Oct 2019 16:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbfJOOCm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Oct 2019 10:02:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:37206 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732011AbfJOOCm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Oct 2019 10:02:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4FC9B2C5;
        Tue, 15 Oct 2019 14:02:39 +0000 (UTC)
Date:   Tue, 15 Oct 2019 16:02:38 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     rostedt@goodmis.org, mingo@redhat.com, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Introduce PERMANENT ftrace_ops flag
In-Reply-To: <f82e57ce-f33f-4ace-514e-75fcba42b5ba@redhat.com>
Message-ID: <alpine.LSU.2.21.1910151555430.13169@pobox.suse.cz>
References: <20191014105923.29607-1-mbenes@suse.cz> <20191014223100.GA16608@redhat.com> <alpine.LSU.2.21.1910151259220.30206@pobox.suse.cz> <f82e57ce-f33f-4ace-514e-75fcba42b5ba@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 15 Oct 2019, Joe Lawrence wrote:

> On 10/15/19 7:23 AM, Miroslav Benes wrote:
> >> Hi Miroslav,
> >>
> >> Maybe we should add a test to verify this new behavior?  See sample
> >> version below (lightly tested).  We can add to this one, or patch
> >> seperately if you prefer.
> > 
> > Thanks a lot, Joe. It looks nice. I'll include it in v3. One question
> > below.
> >   
> >> -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--
> >>
> >>   
> >> >From c8c9f22e3816ca4c90ab7e7159d2ce536eaa5fad Mon Sep 17 00:00:00 2001
> >> From: Joe Lawrence <joe.lawrence@redhat.com>
> >> Date: Mon, 14 Oct 2019 18:25:01 -0400
> >> Subject: [PATCH] selftests/livepatch: test interaction with ftrace_enabled
> >>
> >> Since livepatching depends upon ftrace handlers to implement "patched"
> >> functionality, verify that the ftrace_enabled sysctl value interacts
> >> with livepatch registration as expected.
> >>
> >> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> >> ---
> >>   tools/testing/selftests/livepatch/Makefile    |  3 +-
> >>   .../testing/selftests/livepatch/functions.sh  | 18 +++++
> >>   .../selftests/livepatch/test-ftrace.sh        | 65 +++++++++++++++++++
> >>   3 files changed, 85 insertions(+), 1 deletion(-)
> >>   create mode 100755 tools/testing/selftests/livepatch/test-ftrace.sh
> >>
> >> diff --git a/tools/testing/selftests/livepatch/Makefile
> >> b/tools/testing/selftests/livepatch/Makefile
> >> index fd405402c3ff..1886d9d94b88 100644
> >> --- a/tools/testing/selftests/livepatch/Makefile
> >> +++ b/tools/testing/selftests/livepatch/Makefile
> >> @@ -4,6 +4,7 @@ TEST_PROGS_EXTENDED := functions.sh
> >>   TEST_PROGS := \
> >>    test-livepatch.sh \
> >>    test-callbacks.sh \
> >> -	test-shadow-vars.sh
> >> +	test-shadow-vars.sh \
> >> +	test-ftrace.sh
> >>   
> >>   include ../lib.mk
> >> diff --git a/tools/testing/selftests/livepatch/functions.sh
> >> b/tools/testing/selftests/livepatch/functions.sh
> >> index 79b0affd21fb..556252efece0 100644
> >> --- a/tools/testing/selftests/livepatch/functions.sh
> >> +++ b/tools/testing/selftests/livepatch/functions.sh
> >> @@ -52,6 +52,24 @@ function set_dynamic_debug() {
> >>   		EOF
> >>   }
> >>   
> >> +function push_ftrace_enabled() {
> >> +	FTRACE_ENABLED=$(sysctl --values kernel.ftrace_enabled)
> >> +}
> > 
> > Shouldn't we call push_ftrace_enabled() somewhere at the beginning of the
> > test script? set_dynamic_debug() calls its push_dynamic_debug() directly,
> > but set_ftrace_enabled() is different, because it is called more than once
> > in the script.
> > 
> > One could argue that ftrace_enabled has to be true at the beginning of
> > testing anyway, but I think it would be cleaner. Btw, we should probably
> > guarantee that ftrace_enabled is true when livepatch selftests are
> > invoked.
> > 
> 
> Ah yes, that occurred to me while creating that piece of the patch. Something
> like setup_test_config() that pushes both ftrace and the debugfs, etc. would
> be cleaner for all scripts.  If you're onboard with that idea, I can make that
> revision.

Yes, that would be perfect. Thanks.

Miroslav
