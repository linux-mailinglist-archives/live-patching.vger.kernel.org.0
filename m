Return-Path: <live-patching+bounces-1778-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D6ABF3796
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 22:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B78684E7260
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 20:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E242DFA21;
	Mon, 20 Oct 2025 20:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uCJoUzx2"
X-Original-To: live-patching@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4538B2D73A7
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 20:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760992820; cv=none; b=Wze6+EdI2G/9jWslBRvAObW5RDxU3vDpv64j6snxKnl65t/5NnCc5AXsKCyGrtqCiY2WmXArOo3S6Bk8LaExxWXmr52kilnfDKUGlsn/SRMTpOCov6NJZRMFmRJmVXh6s9WNUDtbEJsGZ9sGYwg/uh1UJn5MhoUpdYC+oTse9ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760992820; c=relaxed/simple;
	bh=9wUkGqUIBXLJujqdoNDRnEhUy5hWTQBgT9hIAnXOT+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=smw4Fx6k6iyNImCLo0SNQhGn+byikd1rbfiZKIstCf/SNhrBuSIPOxE9sZsQ2hTHQBQlCy/RKn8acW/5SP+oNppbTfe3xDLk9RogpuiX467l7VR7jIPnX2xQpTDLzlY+CoiS8NSuPNYNe3BmjGJogZhdGTP9oFWNeuCSu6fFKLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uCJoUzx2; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20251020204015euoutp02c12672fdae8f1c58aafe06930857552c~wTaKugs6S3127731277euoutp02o
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 20:40:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20251020204015euoutp02c12672fdae8f1c58aafe06930857552c~wTaKugs6S3127731277euoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760992815;
	bh=LqJNb4Chs0cDieqVOpjUeWEQ6aUffVpBGo18AK7yOy4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=uCJoUzx2Jd0WGTVxZtD5njK5keWng6uxJA9lJ3lYE0QEaWq3cFNCZegENDQsXQ7sv
	 BjD8gcfmUsNG0JeW4dmu2awRPNCSchF+Julew+FE5EPxSdBeM/vGDH/scpFcq/gGMm
	 00qDrh5WvFlRv6b/GfJBwXN7XpOu7fiiGIJh2T6Y=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20251020204013eucas1p29b00e200fcb635983bda03a4f34616e4~wTaJabuQd2129121291eucas1p2-;
	Mon, 20 Oct 2025 20:40:13 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251020204012eusmtip293bec40fb5818f44f74687d0c53be37d~wTaIZyVML0756007560eusmtip2B;
	Mon, 20 Oct 2025 20:40:12 +0000 (GMT)
Message-ID: <98a11c7b-590b-49e3-99ab-b0857329b0a5@samsung.com>
Date: Mon, 20 Oct 2025 22:40:12 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] module: Fix device table module aliases
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>, Miroslav
	Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz
	<laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza
	<mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, Fazla Mehrab
	<a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay
	Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, Peter
	Zijlstra <peterz@infradead.org>, Alexander Stein
	<alexander.stein@ew.tq-group.com>, Mark Brown <broonie@kernel.org>, Cosmin
	Tanislav <demonsingur@gmail.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251020204013eucas1p29b00e200fcb635983bda03a4f34616e4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20251020175415eucas1p18b060df78fab64a52a29ad10ac25869e
X-EPHeader: CA
X-CMS-RootMailID: 20251020175415eucas1p18b060df78fab64a52a29ad10ac25869e
References: <CGME20251020175415eucas1p18b060df78fab64a52a29ad10ac25869e@eucas1p1.samsung.com>
	<e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>

On 20.10.2025 19:53, Josh Poimboeuf wrote:
> Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
> __KBUILD_MODNAME") inadvertently broke module alias generation for
> modules which rely on MODULE_DEVICE_TABLE().
>
> It removed the "kmod_" prefix from __KBUILD_MODNAME, which caused
> MODULE_DEVICE_TABLE() to generate a symbol name which no longer matched
> the format expected by handle_moddevtable() in scripts/mod/file2alias.c.
>
> As a result, modpost failed to find the device tables, leading to
> missing module aliases.
>
> Fix this by explicitly adding the "kmod_" string within the
> MODULE_DEVICE_TABLE() macro itself, restoring the symbol name to the
> format expected by file2alias.c.
>
> Fixes: 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME")
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Reported-by: Cosmin Tanislav <demonsingur@gmail.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

This fixes the issue observed on my test systems. Thanks!

Closes: 
https://lore.kernel.org/all/d7b49971-8d77-43e2-b0cd-a70c6463ea57@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>


> ---
>   include/linux/module.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index e135cc79aceea..d80c3ea574726 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -251,10 +251,11 @@ struct module_kobject *lookup_or_create_module_kobject(const char *name);
>    */
>   #define __mod_device_table(type, name)	\
>   	__PASTE(__mod_device_table__,	\
> +	__PASTE(kmod_,			\
>   	__PASTE(__KBUILD_MODNAME,	\
>   	__PASTE(__,			\
>   	__PASTE(type,			\
> -	__PASTE(__, name)))))
> +	__PASTE(__, name))))))
>   
>   /* Creates an alias so file2alias.c can find device table. */
>   #define MODULE_DEVICE_TABLE(type, name)					\

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


