Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A114223225F
	for <lists+live-patching@lfdr.de>; Wed, 29 Jul 2020 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgG2QNX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Jul 2020 12:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgG2QNX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Jul 2020 12:13:23 -0400
Received: from linux-8ccs (p57a236d4.dip0.t-ipconnect.de [87.162.54.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5FA920FC3;
        Wed, 29 Jul 2020 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596039202;
        bh=Dr2f1rnIAwAbgJYQlSq8HsSXozp4VHgRlAMcB3TsJwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VbFyGvQaGLh/SJN5nvdnlpgMswUCpssnC9Nl7UBme2OYXtALrCxRXizttfSXu0hB/
         o/qDT0CWgK2s5/EKiaxIsxqNpPFYUsgZb1dMsgY4B4uivr3KQfMr54qT33UYvdO/uH
         lRY6C1kcYcdHG4PvvkTlrguh+GS7BLCg6RendzIw=
Date:   Wed, 29 Jul 2020 18:13:18 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 2/7] modules: mark find_symbol static
Message-ID: <20200729161318.GA30898@linux-8ccs>
References: <20200729062711.13016-1-hch@lst.de>
 <20200729062711.13016-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200729062711.13016-3-hch@lst.de>
X-OS:   Linux linux-8ccs 5.5.0-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Christoph Hellwig [29/07/20 08:27 +0200]:
>find_symbol is only used in module.c.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>

CCing the livepatching ML, as this may or may not impact its users.

AFAIK, the out-of-tree kpatch module had used find_symbol() in the
past, I am not sure what its current status is. I suspect all of its
functionality has been migrated to upstream livepatch already.

>---
> include/linux/module.h | 11 -----------
> kernel/module.c        |  3 +--
> 2 files changed, 1 insertion(+), 13 deletions(-)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index f1fdbeef2153a8..90bdc362be3681 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -590,17 +590,6 @@ struct symsearch {
> 	bool unused;
> };
>
>-/*
>- * Search for an exported symbol by name.
>- *
>- * Must be called with module_mutex held or preemption disabled.
>- */
>-const struct kernel_symbol *find_symbol(const char *name,
>-					struct module **owner,
>-					const s32 **crc,
>-					bool gplok,
>-					bool warn);
>-
> /*
>  * Walk the exported symbol table
>  *
>diff --git a/kernel/module.c b/kernel/module.c
>index 17d64dae756c80..84da96a6d8241c 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -585,7 +585,7 @@ static bool find_exported_symbol_in_section(const struct symsearch *syms,
>
> /* Find an exported symbol and return it, along with, (optional) crc and
>  * (optional) module which owns it.  Needs preempt disabled or module_mutex. */
>-const struct kernel_symbol *find_symbol(const char *name,
>+static const struct kernel_symbol *find_symbol(const char *name,
> 					struct module **owner,
> 					const s32 **crc,
> 					bool gplok,
>@@ -608,7 +608,6 @@ const struct kernel_symbol *find_symbol(const char *name,
> 	pr_debug("Failed to find symbol %s\n", name);
> 	return NULL;
> }
>-EXPORT_SYMBOL_GPL(find_symbol);
>
> /*
>  * Search for module by name: must hold module_mutex (or preempt disabled
>-- 
>2.27.0
>
