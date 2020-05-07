Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC25F1C9E65
	for <lists+live-patching@lfdr.de>; Fri,  8 May 2020 00:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgEGWXd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 May 2020 18:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgEGWXd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 May 2020 18:23:33 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1FE6207DD;
        Thu,  7 May 2020 22:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588889858;
        bh=y9ZhABsB0EXo6BAC1e210uaMX8S6w4Em2EKPNhZICwI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=VwyKmdwInAwzlExGThh9y0vgmuCf2IwPqY/yX6MV+W8x+nuT2imHJ8reMZh0EMwRL
         2sf4ST0OFZfG1bDn4yE9N8jG/FpyPToITTG1FGc8iDmu30hud2HKR5vEdG05/eOg8d
         tarrWllJGaVnDsLgmBthOPVADPI0KipbAJppWe0k=
Date:   Fri, 8 May 2020 00:17:34 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v4 00/11] livepatch,module: Remove .klp.arch and
 module_disable_ro()
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
Message-ID: <nycvar.YFH.7.76.2005080016330.25812@cbobk.fhfr.pm>
References: <cover.1588173720.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 29 Apr 2020, Josh Poimboeuf wrote:

> v4:
> - Fixed rebase bisection regression [Miroslav]
> - Made module_enable_ro() static [Jessica]
> - Added Acked-by's
> 
> v3:
> - klp: split klp_write_relocations() into object/section specific
>   functions [joe]
> - s390: fix plt/got writes [joe]
> - s390: remove text_mutex usage [mbenes]
> - x86: do text_poke_sync() before releasing text_mutex [peterz]
> - split x86 text_mutex changes into separate patch [mbenes]
> 
> v2:
> - add vmlinux.ko check [peterz]
> - remove 'klp_object' forward declaration [mbenes]
> - use text_mutex [jeyu]
> - fix documentation TOC [jeyu]
> - fix s390 issues [mbenes]
> - upstream kpatch-build now supports this
>   (though it's only enabled for Linux >= 5.8)
> 
> These patches add simplifications and improvements for some issues Peter
> found six months ago, as part of his non-writable text code (W^X)
> cleanups.
> 
> Highlights:
> 
> - Remove the livepatch arch-specific .klp.arch sections, which were used
>   to do paravirt patching and alternatives patching for livepatch
>   replacement code.
> 
> - Add support for jump labels in patched code (only for static keys
>   which live in vmlinux).
> 
> - Remove the last module_disable_ro() usage.
> 
> For more background, see this thread:
> 
>   https://lkml.kernel.org/r/20191021135312.jbbxsuipxldocdjk@treble
> 
> This has been tested with kpatch-build integration tests and klp-convert
> selftests.

I have now queued this whole set (with all the gathered Acks) in 
livepatching.git#for-5.8/klp-module-fixups

-- 
Jiri Kosina
SUSE Labs

