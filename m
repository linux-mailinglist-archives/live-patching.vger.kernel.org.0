Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2361BF6DD
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2020 13:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgD3LdQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Apr 2020 07:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgD3LdQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Apr 2020 07:33:16 -0400
Received: from linux-8ccs (p3EE2CE96.dip0.t-ipconnect.de [62.226.206.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B78B2078D;
        Thu, 30 Apr 2020 11:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588246396;
        bh=Q1oNOr8IL473Ob4udYWQ+uFHwVV7Gbu7dfa0Yj6MdNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ngOt2zaGMRHUpdTHiX9hWDndg/wqQdi0j8+CFChEy/Bl+R1c3bpMrp9VtdOCsRvM/
         NkNbxVfj19CEraI6IZkc2bkAAboPNDPtMzZq56usN9/ZCH/nqxj8JMvdk/cQD0gJFC
         bfDJbkrIPYvbmAHOWAFBiM+qS8o9sVgnwFGqy5Rk=
Date:   Thu, 30 Apr 2020 13:33:12 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v4 00/11] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200430113309.GB4436@linux-8ccs>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Josh Poimboeuf [29/04/20 10:24 -0500]:
>v4:
>- Fixed rebase bisection regression [Miroslav]
>- Made module_enable_ro() static [Jessica]
>- Added Acked-by's
>
>v3:
>- klp: split klp_write_relocations() into object/section specific
>  functions [joe]
>- s390: fix plt/got writes [joe]
>- s390: remove text_mutex usage [mbenes]
>- x86: do text_poke_sync() before releasing text_mutex [peterz]
>- split x86 text_mutex changes into separate patch [mbenes]
>
>v2:
>- add vmlinux.ko check [peterz]
>- remove 'klp_object' forward declaration [mbenes]
>- use text_mutex [jeyu]
>- fix documentation TOC [jeyu]
>- fix s390 issues [mbenes]
>- upstream kpatch-build now supports this
>  (though it's only enabled for Linux >= 5.8)
>
>These patches add simplifications and improvements for some issues Peter
>found six months ago, as part of his non-writable text code (W^X)
>cleanups.
>
>Highlights:
>
>- Remove the livepatch arch-specific .klp.arch sections, which were used
>  to do paravirt patching and alternatives patching for livepatch
>  replacement code.
>
>- Add support for jump labels in patched code (only for static keys
>  which live in vmlinux).
>
>- Remove the last module_disable_ro() usage.

Nice! Glad the .klp.arch sections are going away. For kernel/module.c
and include/linux/module.h parts:

Acked-by: Jessica Yu <jeyu@kernel.org>


