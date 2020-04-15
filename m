Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C001AAB43
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2020 17:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbgDOPCX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Apr 2020 11:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbgDOPCV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Apr 2020 11:02:21 -0400
Received: from linux-8ccs.fritz.box (p3EE2C7AC.dip0.t-ipconnect.de [62.226.199.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF8572076A;
        Wed, 15 Apr 2020 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586962940;
        bh=xa6f99U25qSXApPs4fRkURvkgMb0zfOGAin9cSoNDkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nPEAM9HpwWDso+/0bKiVX7Hz8ysCJ9twOqNFYtr78pcJDBppKm/dk0lGyy8qh4DAv
         BYwNcLT7AKrrRvAG0cu5iR+LKDGJy6OY2Db0R2pQz8tI0J8ddjLod71vS9dhF0abMP
         8f/75JkQ35kBnOjfXTDVg3/YbJ4yGCrsBw7tSoJo=
Date:   Wed, 15 Apr 2020 17:02:16 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] livepatch: Remove module_disable_ro() usage
Message-ID: <20200415150216.GA6164@linux-8ccs.fritz.box>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <9f0d8229bbe79d8c13c091ed70c41d49caf598f2.1586881704.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9f0d8229bbe79d8c13c091ed70c41d49caf598f2.1586881704.git.jpoimboe@redhat.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Josh Poimboeuf [14/04/20 11:28 -0500]:
>With arch_klp_init_object_loaded() gone, and apply_relocate_add() now
>using text_poke(), livepatch no longer needs to use module_disable_ro().
>
>The text_mutex usage can also be removed -- its purpose was to protect
>against module permission change races.
>
>Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
>---
> kernel/livepatch/core.c | 8 --------
> 1 file changed, 8 deletions(-)
>
>diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>index 817676caddee..3a88639b3326 100644
>--- a/kernel/livepatch/core.c
>+++ b/kernel/livepatch/core.c
>@@ -767,10 +767,6 @@ static int klp_init_object_loaded(struct klp_patch *patch,
> 	struct klp_modinfo *info = patch->mod->klp_info;
>
> 	if (klp_is_module(obj)) {
>-
>-		mutex_lock(&text_mutex);
>-		module_disable_ro(patch->mod);
>-

Don't you still need the text_mutex to use text_poke() though?
(Through klp_write_relocations -> apply_relocate_add -> text_poke)
At least, I see this assertion there:

void *text_poke(void *addr, const void *opcode, size_t len)
{
	lockdep_assert_held(&text_mutex);

	return __text_poke(addr, opcode, len);
}

Jessica
