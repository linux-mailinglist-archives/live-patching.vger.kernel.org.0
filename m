Return-Path: <live-patching+bounces-1770-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD136BF2B00
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 19:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4651F189A5A2
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 17:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F99E331A70;
	Mon, 20 Oct 2025 17:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtBtFKOc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7700A331A5A;
	Mon, 20 Oct 2025 17:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760980958; cv=none; b=m3HSJwTSrhBBFL3djbkDt5FHzJFcgSzxQGQw2IWlnDdMkRNr5MGprSuimLcr4F+pvjgCczpTAxRXQXIYXXANC0v37DuNvZQ0AgTZPyjAv9MLb7EU6+WzheX3J8MbNrntHtz1kwh3zYP8irWDWKOEZlJuQNQnra9cpI90Af7xSU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760980958; c=relaxed/simple;
	bh=v42N1F4aHiEGS6LzWOOVOgQlIThxqYuBv7IEvZAT+ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMmU8b0xeVPJhbcCAu6jKOVoGXjl3UtZFiAm7qUPj2JUap8oH2sJhvk8yKgTiY9Hb9StdTTm1AMCaVaJL/WS1XOwfejGyIVbqdIYamSFMMk8WxTKeaNZTyJt0yL1hkvkgCs8hS+d1posuiUxg6MvC3mQ/5ouxtt1zRb4zogJXvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtBtFKOc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F2DC4CEFE;
	Mon, 20 Oct 2025 17:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760980957;
	bh=v42N1F4aHiEGS6LzWOOVOgQlIThxqYuBv7IEvZAT+ZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WtBtFKOc8NqE+SyW41eWULOUX3eoFQoUpWHXaLukkz3NnEzA14AkGXEWH0uuNxHd1
	 Eq0eqOuqkdfSS7zRH7wrbNO1KfxDfJ6igEr3RUA0awAwF2z2/PefM5TEcjZlgvfQc7
	 TPpMUEcIIaUJDGbkFKnkV2ykcX0fhcOHVQM9UgiKxZ1Prct/VFB05Z/p0FYe6hizHI
	 fDk8zuWBDId4dw4+3V/dTFGU78QMDk2Ljw9TJ/XTsfwPhVa+UU5U3cBqY8VNn9tZdx
	 LMdk4Yq//Ibu7fExdKZXyoKA7yYIj1qc7i6ZhKnuhn4GhhgruxLAg1gzM6T9rl6zZC
	 gDQbXRELn+8xw==
Date: Mon, 20 Oct 2025 10:22:35 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Mark Brown <broonie@kernel.org>, 
	Cosmin Tanislav <demonsingur@gmail.com>
Subject: Re: [PATCH v4 08/63] kbuild: Remove 'kmod_' prefix from
 __KBUILD_MODNAME
Message-ID: <ycrgjcczkgt6morojzfpkjyg4ehrm5ova2hzzxy2dxv23hhyre@nf5bltmr4lxm>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
 <5936475.DvuYhMxLoT@steina-w>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5936475.DvuYhMxLoT@steina-w>

On Mon, Oct 20, 2025 at 02:20:35PM +0200, Alexander Stein wrote:
> Hi,
> 
> Am Mittwoch, 17. September 2025, 18:03:16 CEST schrieb Josh Poimboeuf:
> > In preparation for the objtool klp diff subcommand, remove the arbitrary
> > 'kmod_' prefix from __KBUILD_MODNAME and instead add it explicitly in
> > the __initcall_id() macro.
> > 
> > This change supports the standardization of "unique" symbol naming by
> > ensuring the non-unique portion of the name comes before the unique
> > part.  That will enable objtool to properly correlate symbols across
> > builds.
> > 
> > Cc: Masahiro Yamada <masahiroy@kernel.org>
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Starting with this commit 6717e8f91db71 ("kbuild: Remove 'kmod_' prefix
> from __KBUILD_MODNAME") in next-20251020 I don't get any
> module aliases anymore.
> modinfo spi-fsl-dspi.ko returns:
> > filename:       /work/repo/linux/build_arm64/drivers/spi/spi-fsl-dspi.ko
> > alias:          platform:fsl-dspi
> > license:        GPL
> > description:    Freescale DSPI Controller Driver
> > depends:        
> > intree:         Y
> > name:           spi_fsl_dspi
> > vermagic:       6.18.0-rc1+ SMP preempt mod_unload modversions aarch64
> 
> but it should be like this:
> > filename:       /work/repo/linux/build_arm64/drivers/spi/spi-fsl-dspi.ko
> > alias:          platform:fsl-dspi
> > license:        GPL
> > description:    Freescale DSPI Controller Driver
> > alias:          of:N*T*Cnxp,s32g2-dspiC*

Thanks, this patch broke the MODULE_DEVICE_TABLE() macro, as it no
longer produces the format expected by scripts/mod/file2alias.c.

I didn't see this in x86 testing since it doesn't have device tree.

I will post the following fix shortly:

diff --git a/include/linux/module.h b/include/linux/module.h
index e135cc79aceea..d80c3ea574726 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -251,10 +251,11 @@ struct module_kobject *lookup_or_create_module_kobject(const char *name);
  */
 #define __mod_device_table(type, name)	\
 	__PASTE(__mod_device_table__,	\
+	__PASTE(kmod_,			\
 	__PASTE(__KBUILD_MODNAME,	\
 	__PASTE(__,			\
 	__PASTE(type,			\
-	__PASTE(__, name)))))
+	__PASTE(__, name))))))
 
 /* Creates an alias so file2alias.c can find device table. */
 #define MODULE_DEVICE_TABLE(type, name)					\

