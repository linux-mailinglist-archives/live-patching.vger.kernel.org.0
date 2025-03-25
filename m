Return-Path: <live-patching+bounces-1328-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B64B6A6ED47
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 11:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 909781894BCA
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 10:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6E8254851;
	Tue, 25 Mar 2025 10:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g+a8xMGL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF3518FDD5
	for <live-patching@vger.kernel.org>; Tue, 25 Mar 2025 10:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742896918; cv=none; b=fYSSIocZgcLZzI8L119O5hzJ6IQSdLZ6Vw6JFnooxskapfA3TrDh5DCCt1K+RUqYqZA+/TuftcDkFb2NS3de1XEzBFN5xstUra2VgR8S4qvTObDIH7claTzS7rPIH+/+ABTzhy0IEXGAygyA/V6IeGKISso8HkEiDRdn9gRfIPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742896918; c=relaxed/simple;
	bh=u1Az67vlS+7L2hZ01L/haLmuxE5Ik84O0pup0jtGQxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DImzPIUp7cCVlgnlA5ZgqXK7a2s8VksKZgdDeqjbxLMxTOf7oUFoVQK7QTm5SX8ygaio96EkyfZ3EyCk4qh+mrJehMmrxyDcmfcAicrMOmfl5u/IyQ/M2Nkv2PGOiRGfo3vwMD2XTIuyhLZsnn9BgdTM7CqUcc/AkyJJ/lRee0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g+a8xMGL; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso338460f8f.2
        for <live-patching@vger.kernel.org>; Tue, 25 Mar 2025 03:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742896913; x=1743501713; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nMblP3h4cEOnPAdB6DxVK+neSqUEhMjzJVpUeyv9ozY=;
        b=g+a8xMGLL9OiiH6nIE6u0tk8OXYneE4+OG5jUwjOelLkHzcPN0YkYC+s8D1iiH/+uB
         nmxvXioadqRhoVpsJTEgBVHPvYEjCV/zZX/8RSkn5426nmsHy+17CF1gziXzmMKALfpo
         AjuSY19UwXeDMrT4AiW065dmJ2urzps6sU83n1ZIVbmavOzNMR0ln1hKdUosFEjENCBz
         OrI+AWxPh1rGs+aBg6MiG0poNeTu8QhSLcfCWZ+tafjlDyCO+3Qtx9rJBNOiIuYRavWp
         teHslpSaaeWq4jZd9XwOj437NE2duXuaKDLovFK5ExAPBSsn+bBjigzCxYrMRXrPd7hl
         jzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742896913; x=1743501713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMblP3h4cEOnPAdB6DxVK+neSqUEhMjzJVpUeyv9ozY=;
        b=wOVQDklnDUuNsZ4VPAa8PD7C+5TyKlkESOAwq4KV/2wrzQqQ3luuqO1cIsDUyYtmAg
         VKYi8RwLQ57s2PMBaYHf9l8dvEKHJytOg+b79T60nYSlZjC8+zqJkzK5EVolxZijOTgg
         Z9lkL2a5trwZdEkmtl2IOr4olNCVHcudP1kvF/Xv3vycnlI5Y9/T3mX6friib6uhQ/yO
         JZq8Y2+b70q1thslHDdeonAsPwq5KDIq6sA8q48Qmk16AqTNhJUGS6FW5evZFG1HJ7TQ
         aSO1APHT749rLgnapwiFSKOjOijmMvfLYGlBVGLWNcZSAuuDFV+YbkU16tr1EgY4vyl8
         nqog==
X-Forwarded-Encrypted: i=1; AJvYcCUBim1gs+WiwpE9xLFzdAHtvdEbu228JYLoP9tJIN3dS9j1TlY+GoVPvOCKpOxFD0dfhHH1GzF8oxx3YrKx@vger.kernel.org
X-Gm-Message-State: AOJu0YznxMgXHXaU8qXeQE4ycAwf+/GUcZ+xzPyCPNmiXO77etzRu6S8
	YK4qjqpjT4DY06i2cffgxQK31w3YBx8+0521rImFqCQ7f++a/kTUnrhdvJzuQNc=
X-Gm-Gg: ASbGncsDCJyi0IRAJajgHTXvMw48D4S90RXIleJVhN4ZIHf0PWvP93fLFwQR2myR0bC
	qpctaT0JjUL7o6o9Scg+KW9J4pBfU7o5lB7JTNCrji8xJToGMjGU816+fgei5h5CdaS5/IxcJO6
	MZqTVk5pbazBNnQsoRSJqaJK45gtRMunGoCdf/D9O9tX19fdlpMOo3TtJutkVq8wotVCRgzD6mM
	71HyaeUX7rvjdJy39qgwyzfqYMXZlxbGAUNUJ8qDpcX51dU0Z3RCppd2/0Lqi9pW8xgHvNmfCDp
	nHNDHYBn9xsMkLA1tFxOdCeTDtvCOh+rm38Sna470Uda
X-Google-Smtp-Source: AGHT+IENT/IPKbT6Qsm0wWCiMdCWIBWfOpP5sfGyY1vKH3mW6SLMa0nz4G3RYr9l3qhX6nvzCnZKNA==
X-Received: by 2002:a5d:6d08:0:b0:390:e889:d1cf with SMTP id ffacd0b85a97d-3997f92da8fmr12375291f8f.37.1742896913536;
        Tue, 25 Mar 2025 03:01:53 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d440ed793sm200277465e9.39.2025.03.25.03.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 03:01:53 -0700 (PDT)
Date: Tue, 25 Mar 2025 11:01:51 +0100
From: Petr Mladek <pmladek@suse.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] samples/livepatch: add module descriptions
Message-ID: <Z-J--iv8LzgArWAX@pathway.suse.cz>
References: <20250324173242.1501003-1-arnd@kernel.org>
 <20250324173242.1501003-3-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324173242.1501003-3-arnd@kernel.org>

On Mon 2025-03-24 18:32:28, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Every module should have a description, so add one for each of these modules.
> 
> --- a/samples/livepatch/livepatch-callbacks-busymod.c
> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
> @@ -56,4 +56,5 @@ static void livepatch_callbacks_mod_exit(void)
>  
>  module_init(livepatch_callbacks_mod_init);
>  module_exit(livepatch_callbacks_mod_exit);
> +MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks");

This is another support module similar to livepatch-callbacks-mod.c.
I would use the same description, here:

MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks, support module");

>  MODULE_LICENSE("GPL");
> diff --git a/samples/livepatch/livepatch-callbacks-demo.c b/samples/livepatch/livepatch-callbacks-demo.c
> index 11c3f4357812..9e69d9caed25 100644
> --- a/samples/livepatch/livepatch-callbacks-demo.c
> +++ b/samples/livepatch/livepatch-callbacks-demo.c
> @@ -192,5 +192,6 @@ static void livepatch_callbacks_demo_exit(void)
>  
>  module_init(livepatch_callbacks_demo_init);
>  module_exit(livepatch_callbacks_demo_exit);
> +MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks");
>  MODULE_LICENSE("GPL");
>  MODULE_INFO(livepatch, "Y");
> diff --git a/samples/livepatch/livepatch-callbacks-mod.c b/samples/livepatch/livepatch-callbacks-mod.c
> index 2a074f422a51..d1851b471ad9 100644
> --- a/samples/livepatch/livepatch-callbacks-mod.c
> +++ b/samples/livepatch/livepatch-callbacks-mod.c
> @@ -38,4 +38,5 @@ static void livepatch_callbacks_mod_exit(void)
>  
>  module_init(livepatch_callbacks_mod_init);
>  module_exit(livepatch_callbacks_mod_exit);
> +MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks, support module");
>  MODULE_LICENSE("GPL");

The rest looks good. With the above change:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Thanks a lot for fixing this.

Arnd, should I push this via the livepatch tree or would you prefer to push
the entire patchset together? Both ways work for me.

Best Regards,
Petr

