Return-Path: <live-patching+bounces-1788-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA79BFB3B6
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 11:54:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BE1734E6512
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 09:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2581A317D;
	Wed, 22 Oct 2025 09:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sWBRH/+q"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706BD313E37
	for <live-patching@vger.kernel.org>; Wed, 22 Oct 2025 09:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761126840; cv=none; b=ZFcqZQ0iedESpH+Wq/uUFV9gdJg46uPttRu/5/EFnJ4jCsS9IxGIw1Bl4kdh5t1TkbsTEAtAvrzZbGwjReTI7hjHgsQtU+XCYHmdzOinNWzrCORjjCZ/yt3Yt8I/vspa1CBlYa4wlxuRtq/fdtZTYRrcQB8qIregb3uFUP/frlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761126840; c=relaxed/simple;
	bh=p6P4qcqDA3YLsBFfKyvteFlo1EPQ1YrLjGB+faTBjmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwOa196vbIVDDFgCDZSXSJwHJGWoUCOyVFk7gQYFvpw1z6JxTI1zcgcczGHQTR13+/jEF3KyQNJhHYQOpcNowtXdSmpJwPsdy4tL1OfuJgZGBUu8D8brs930iamBU/zThpq1P58Zn1EsoCIlbuk0bSkv/Z2+XQYnBekSvg8Q3zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sWBRH/+q; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5903e6fc386so1154318e87.2
        for <live-patching@vger.kernel.org>; Wed, 22 Oct 2025 02:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761126836; x=1761731636; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pbt/O4Tu98SupoHCWRQkxaJ7zq2Tk+PByeJW8+2lzZw=;
        b=sWBRH/+qELlMFNMskkJao8UpNj9GtiHYk3iSuW9xXvpt1gjwdF3MApH6cX3HWnRGAd
         PijfJ4PVJMiTVc8f6kTOk1tH9vBNis2XpC2CFOIVDE3zfANbPAxdih5EriO5nz/49yoy
         H8C3y2ZjNwRpxURYyv0ik+ojP+BSgkk89bSfhQBSWQ4rP6i0TjETW/oMsxmPideTc05K
         DbiNOxQRaM0eSo3NgHUcjS3XS2kP/GI1YvFRdDkUwkQammn+mIGtLF8njUsgCTN1fo6z
         +2t6JTZS1HIcApaMEdLyAnEaRXhEwonLdDk5hWI/6w5L9fYP6FxKf0GFC5NeParoJEFo
         ODSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761126836; x=1761731636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbt/O4Tu98SupoHCWRQkxaJ7zq2Tk+PByeJW8+2lzZw=;
        b=AMNfzuoGLikn1V/VuYuKlRQ7Kzh+pI4jtjwNREPWuCNakrDcNXs2Wa50DIBSqhAIFq
         KndFCFhPjh8Td/Nt/MVOVv4lBRHeMe0N8q9lernwZHqvC155AOSTqQ/iSbXfaz7XeNZG
         2PL5HSxg2V+n/FUUdCxM73CnHNGaADX8QnbjstvPmYW2YlyMFNJOqDSpjMlQ4D+0vNX6
         TXxmsX9fIWVsUOQkjzMa/5FQTyYGipn07P1pOv/Xa/TX5m+PqnhJToceywOwYptcJxnh
         2rS6GHND5PWAZH0yDhrftI92r7AY/Rk9Wb8BQXeCshQH+tp+HUt3HRRQAQRAsTTwzlEY
         Oraw==
X-Forwarded-Encrypted: i=1; AJvYcCVksHB7QEnoQh/04Yd0/ncyINXB5mf9dehT+Rxmwbr0mCBWOjEsODkRUqCZMiKDO26/dM4nhI1uFhfEdTV/@vger.kernel.org
X-Gm-Message-State: AOJu0Yw69VVIqcqtjzyUZh0lTlYMGvBwzNX1y06BIfiEjzzZLZg9NJHQ
	KofrKnr6LnGwzF60O4PSLDoBqu9tqeNSk0y1BS5MFD3QkQboRRtjdth3ihqrhBlAtec=
X-Gm-Gg: ASbGncuVYlZQ2Uh9EwZ3A117Z5pAQkeVNp5YYYE6Pn1ty6tMDBUlnTxUIvqnbOwYCKF
	DPnhzxlL0t6lqog1tglmXn7pBg7qwKR9Qn2EY7rSmNIqKBJBonAnGa0boi/Wn/Hf2OSpo0B1nhw
	a91WG2vaCk7/eShZXIwK5iM7Kao5gNrHfmvFZRlTjo2EACpc2yxPyHCQu+sbbrrnb3sIttUSV19
	KmLQGpTocVai1isHqoni0bBWWwCYcSIi/uqFNbD8GwSlfPVy1zWsv2hvMyGTAOq5ogv54X1cXaB
	o7V9+JSnriIPyWgm1X8QWbb3/1xtkJNLscW8mWOXUGGu+Tr1cdulDbn58p44R+geHoCQgGqvKqN
	dgjwA3u11/YWkGnkdpg9NzQRvhfYY47PxBIub3p8A7Jq/m/ZBlo8NUixx1rmRn4xE36rnwNLOHd
	jjeDIMV40ejOG47lYXU2JlLiFJc+8GcHrwXB29odfzGcb4
X-Google-Smtp-Source: AGHT+IHiSJK/QTZ2b4xHqPRM58bigb9XVQRBUletKW3JCiAXnSvp7jtl+E7uu6ozuEh3jkAPIKB1aw==
X-Received: by 2002:a05:6512:401b:b0:58a:ffcc:37b2 with SMTP id 2adb3069b0e04-591ea2cbdf8mr1181159e87.2.1761126836431;
        Wed, 22 Oct 2025 02:53:56 -0700 (PDT)
Received: from monster (c-85-229-7-191.bbcust.telenor.se. [85.229.7.191])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-591eaace758sm1808801e87.114.2025.10.22.02.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 02:53:55 -0700 (PDT)
Date: Wed, 22 Oct 2025 11:53:54 +0200
From: Anders Roxell <anders.roxell@linaro.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Cosmin Tanislav <demonsingur@gmail.com>
Subject: Re: [PATCH v4 08/63] kbuild: Remove 'kmod_' prefix from
 __KBUILD_MODNAME
Message-ID: <aPipsiGv2OyZyIv7@monster>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <f382dddad4b7c8079ce3dd91e5eaea921b03af72.1758067942.git.jpoimboe@kernel.org>
 <5936475.DvuYhMxLoT@steina-w>
 <ycrgjcczkgt6morojzfpkjyg4ehrm5ova2hzzxy2dxv23hhyre@nf5bltmr4lxm>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ycrgjcczkgt6morojzfpkjyg4ehrm5ova2hzzxy2dxv23hhyre@nf5bltmr4lxm>

On 2025-10-20 10:22, Josh Poimboeuf wrote:
> On Mon, Oct 20, 2025 at 02:20:35PM +0200, Alexander Stein wrote:
> > Hi,
> > 
> > Am Mittwoch, 17. September 2025, 18:03:16 CEST schrieb Josh Poimboeuf:
> > > In preparation for the objtool klp diff subcommand, remove the arbitrary
> > > 'kmod_' prefix from __KBUILD_MODNAME and instead add it explicitly in
> > > the __initcall_id() macro.
> > > 
> > > This change supports the standardization of "unique" symbol naming by
> > > ensuring the non-unique portion of the name comes before the unique
> > > part.  That will enable objtool to properly correlate symbols across
> > > builds.
> > > 
> > > Cc: Masahiro Yamada <masahiroy@kernel.org>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > 
> > Starting with this commit 6717e8f91db71 ("kbuild: Remove 'kmod_' prefix
> > from __KBUILD_MODNAME") in next-20251020 I don't get any
> > module aliases anymore.
> > modinfo spi-fsl-dspi.ko returns:
> > > filename:       /work/repo/linux/build_arm64/drivers/spi/spi-fsl-dspi.ko
> > > alias:          platform:fsl-dspi
> > > license:        GPL
> > > description:    Freescale DSPI Controller Driver
> > > depends:        
> > > intree:         Y
> > > name:           spi_fsl_dspi
> > > vermagic:       6.18.0-rc1+ SMP preempt mod_unload modversions aarch64
> > 
> > but it should be like this:
> > > filename:       /work/repo/linux/build_arm64/drivers/spi/spi-fsl-dspi.ko
> > > alias:          platform:fsl-dspi
> > > license:        GPL
> > > description:    Freescale DSPI Controller Driver
> > > alias:          of:N*T*Cnxp,s32g2-dspiC*
> 
> Thanks, this patch broke the MODULE_DEVICE_TABLE() macro, as it no
> longer produces the format expected by scripts/mod/file2alias.c.
> 
> I didn't see this in x86 testing since it doesn't have device tree.
> 
> I will post the following fix shortly:

Tested-by: Anders Roxell <anders.roxell@linaro.org>

When can we expect it?

Cheers,
Anders

> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index e135cc79aceea..d80c3ea574726 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -251,10 +251,11 @@ struct module_kobject *lookup_or_create_module_kobject(const char *name);
>   */
>  #define __mod_device_table(type, name)	\
>  	__PASTE(__mod_device_table__,	\
> +	__PASTE(kmod_,			\
>  	__PASTE(__KBUILD_MODNAME,	\
>  	__PASTE(__,			\
>  	__PASTE(type,			\
> -	__PASTE(__, name)))))
> +	__PASTE(__, name))))))
>  
>  /* Creates an alias so file2alias.c can find device table. */
>  #define MODULE_DEVICE_TABLE(type, name)					\

