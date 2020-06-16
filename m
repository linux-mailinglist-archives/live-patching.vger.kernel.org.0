Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933671FAEE0
	for <lists+live-patching@lfdr.de>; Tue, 16 Jun 2020 13:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgFPLFg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 16 Jun 2020 07:05:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:56130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgFPLFg (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 16 Jun 2020 07:05:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3DDCAE43;
        Tue, 16 Jun 2020 11:05:38 +0000 (UTC)
Date:   Tue, 16 Jun 2020 13:05:34 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 0/4] selftests/livepatch: small script cleanups
In-Reply-To: <20200615172756.12912-1-joe.lawrence@redhat.com>
Message-ID: <alpine.LSU.2.21.2006161305140.20740@pobox.suse.cz>
References: <20200615172756.12912-1-joe.lawrence@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 15 Jun 2020, Joe Lawrence wrote:

> This is a small collection of tweaks for the shellscript side of the
> livepatch tests.  If anyone else has a small cleanup (or even just a
> suggestion for a low-hanging change) and would like to tack it onto the
> set, let me know.
> 
> based-on: livepatching.git, for-5.9/selftests-cleanup
> merge-thru: livepatching.git
> 
> v2:
> - use consistent start_test messages from the original echoes [mbenes]
> - move start_test invocations to just after their descriptions [mbenes]
> - clean up $SAVED_DMSG on trap EXIT [pmladek]
> - grep longer kernel taint line, avoid word-matching [mbenes, pmladek]
> - add "===== TEST: $test =====" delimiter patch [pmladek]
> 
> Joe Lawrence (4):
>   selftests/livepatch: Don't clear dmesg when running tests
>   selftests/livepatch: use $(dmesg --notime) instead of manually
>     filtering
>   selftests/livepatch: refine dmesg 'taints' in dmesg comparison
>   selftests/livepatch: add test delimiter to dmesg
> 
>  tools/testing/selftests/livepatch/README      | 16 +++---
>  .../testing/selftests/livepatch/functions.sh  | 32 ++++++++++-
>  .../selftests/livepatch/test-callbacks.sh     | 55 ++++---------------
>  .../selftests/livepatch/test-ftrace.sh        |  4 +-
>  .../selftests/livepatch/test-livepatch.sh     | 12 +---
>  .../selftests/livepatch/test-shadow-vars.sh   |  4 +-
>  .../testing/selftests/livepatch/test-state.sh | 21 +++----
>  7 files changed, 63 insertions(+), 81 deletions(-)

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
