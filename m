Return-Path: <live-patching+bounces-1764-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0579BF1690
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 15:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E80AC188440B
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 13:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BF4C31DDB9;
	Mon, 20 Oct 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="B9zIvzwJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D813148AD
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760965206; cv=none; b=IYMlvSgLOgfwyjvy4Hjx1Rnk4CIhs2GjQa77WzWR0bv9GuKOO9CbyVusBRJRwSAkNDMp61CnAfBJF19RKsCsWksytYsujGB8UnR+wgH7lwwruXTeFJFEDEJauVaa69Tb8mJy+D7MpbTooVrIXxqHDig9Yzl6DU/zQDTTywvWQU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760965206; c=relaxed/simple;
	bh=WbxwA613BWoK+zVhFBSO3/IjK9L9I022ws6w+bJjWB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=er0oAFcr88YL/E04U/x1pdSbfxLGe+M9yE/ET2dWMKLwJUQ5gp04uvDWfFsV+rVK/Zq45uopDgze0VAWeqiNsSQCAF17CQIfWm8oeGGnyRlib2iwVGP7LOQV+ddMtcjFAfOyuAwKSd6Eb4XWRZRGuRiZZ9YM3NH5IuuWkp4BRno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=B9zIvzwJ; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20251020130002euoutp021ea3fd410ea9c2a7d937f2cff5f5b721~wNIV9z9A63104631046euoutp02F
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 13:00:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20251020130002euoutp021ea3fd410ea9c2a7d937f2cff5f5b721~wNIV9z9A63104631046euoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760965202;
	bh=2QjRYOczjrQhp6rJw91bDYI7ZlyYkkR4wbgGlMr0w+U=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=B9zIvzwJ1keydsypVX4ndzOLtFsQbcVwhJ4C0LEm1LFjopYV7W/efE4R5P1rW6SIT
	 MV/JO5VAnyYKwPnwVh7L6XS5cYuM1mBygzgEX1GO2bmzaLAUoiE6WE623biq59E4Vh
	 Y2VAlGcy2M7gt/aLidjMUIVvwTRLrAZs9xIpbWQQ=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20251020130001eucas1p259c59daada89ad0fece76b7a86581f0e~wNIVQ5esi0845908459eucas1p2N;
	Mon, 20 Oct 2025 13:00:01 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251020125959eusmtip1c2cef3f1f0be5580e63172cd596292f5~wNITlJw540653206532eusmtip1U;
	Mon, 20 Oct 2025 12:59:59 +0000 (GMT)
Message-ID: <d7b49971-8d77-43e2-b0cd-a70c6463ea57@samsung.com>
Date: Mon, 20 Oct 2025 14:59:59 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v4 08/63] kbuild: Remove 'kmod_' prefix from
 __KBUILD_MODNAME
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>, Miroslav
	Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz
	<laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza
	<mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, Fazla Mehrab
	<a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay
	Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, Peter
	Zijlstra <peterz@infradead.org>, Masahiro Yamada <masahiroy@kernel.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251020130001eucas1p259c59daada89ad0fece76b7a86581f0e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20251020130001eucas1p259c59daada89ad0fece76b7a86581f0e
X-EPHeader: CA
X-CMS-RootMailID: 20251020130001eucas1p259c59daada89ad0fece76b7a86581f0e
References: <cover.1758067942.git.jpoimboe@kernel.org>
	<f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
	<CGME20251020130001eucas1p259c59daada89ad0fece76b7a86581f0e@eucas1p2.samsung.com>

On 17.09.2025 18:03, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, remove the arbitrary
> 'kmod_' prefix from __KBUILD_MODNAME and instead add it explicitly in
> the __initcall_id() macro.
>
> This change supports the standardization of "unique" symbol naming by
> ensuring the non-unique portion of the name comes before the unique
> part.  That will enable objtool to properly correlate symbols across
> builds.
>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>


This patch landed recently in linux-next as commit 6717e8f91db7 
("kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME"). In my tests I 
found that it completely breaks automatic modules loading on all tested 
boards (ARM 32bit, ARM 64bit and RiscV64 based), what looks like some 
kind of a generic issue. Reverting it on top of current linux-next fixes 
this issue.


> ---
>   include/linux/init.h | 3 ++-
>   scripts/Makefile.lib | 2 +-
>   2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 17c1bc712e234..40331923b9f4a 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -200,12 +200,13 @@ extern struct module __this_module;
>   
>   /* Format: <modname>__<counter>_<line>_<fn> */
>   #define __initcall_id(fn)					\
> +	__PASTE(kmod_,						\
>   	__PASTE(__KBUILD_MODNAME,				\
>   	__PASTE(__,						\
>   	__PASTE(__COUNTER__,					\
>   	__PASTE(_,						\
>   	__PASTE(__LINE__,					\
> -	__PASTE(_, fn))))))
> +	__PASTE(_, fn)))))))
>   
>   /* Format: __<prefix>__<iid><id> */
>   #define __initcall_name(prefix, __iid, id)			\
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 1d581ba5df66f..b955602661240 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -20,7 +20,7 @@ name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
>   name-fix = $(call stringify,$(call name-fix-token,$1))
>   basename_flags = -DKBUILD_BASENAME=$(call name-fix,$(basetarget))
>   modname_flags  = -DKBUILD_MODNAME=$(call name-fix,$(modname)) \
> -		 -D__KBUILD_MODNAME=kmod_$(call name-fix-token,$(modname))
> +		 -D__KBUILD_MODNAME=$(call name-fix-token,$(modname))
>   modfile_flags  = -DKBUILD_MODFILE=$(call stringify,$(modfile))
>   
>   _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(target-stem).o), \

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


