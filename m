Return-Path: <live-patching+bounces-759-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2557E9ADF0B
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 10:21:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6CFB28A52F
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 08:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D432B1B218E;
	Thu, 24 Oct 2024 08:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VAR3QYng"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3A31AF0BC
	for <live-patching@vger.kernel.org>; Thu, 24 Oct 2024 08:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729758060; cv=none; b=gmR002GBNaS9BcE6yk5IXeeE+Uvq1E+3vzdurfM0z3FuR44wCgPpkrN0vDlz3T5PZ129Z++jze0PpLqpl0M7QX6gaC2u7Z4M+RRDfUwwlnEJTrTpAzYrMyNpQyBOQdWjKYIwYXa9b4TGznhvwCpIbjFHSxd27uSDE24wG4+5TNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729758060; c=relaxed/simple;
	bh=mKG+emQRV1DyZn74gYnOgMb9nlYigftCeEICRCOHpg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCQfoDzcKthqN3587I6InWgmiyzHVkvtBejWC6cp9mC4q5JhBXxngEnY/EixZijRjfHJa6fkpq9wjLx2XkCIreKJvDea1JoOO11uT3kYmCPZ+k16KHYSBQNR2wouygtttrwWb/uXqrpQWdCHU13yUlI4B1kxTadut58HGFAHcaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VAR3QYng; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4314a26002bso6658505e9.0
        for <live-patching@vger.kernel.org>; Thu, 24 Oct 2024 01:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1729758056; x=1730362856; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8E/DqGz7VCwtU5gl7bt7J+sBxvJkxJvY71TRgOhyb8w=;
        b=VAR3QYngMWrcLGiF5n0Zb7bNSLXS0uc84RNDqRYFHULT5x4lMPhTnX3HZFljBccVxL
         U5Ziaqrs4UQ0XbBT9Ir8L0U8lb4Nc2ov4shFxhkgT3iUq1EGsSDvd5P40ufqEk+SHA80
         FxpCXn13FUxgfy8N3cZGPR3+eEgC+iy3BZ2dwsdS8i913U/0mkV3p4opF2AzEc4UGmjn
         7Bn4W/aylu2ZQT+omo9/CwjOc4XpTZY9CCVpKZ+3cveNLFbB3ASfCKsZ2neQxwBcDxSd
         +3u/b+xYzo++tFkoL9BhLp0vHLSxJYPAfg4G9qiJgK4JhlVsWz8ek6xCvxWxBol0aN3a
         b+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729758056; x=1730362856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8E/DqGz7VCwtU5gl7bt7J+sBxvJkxJvY71TRgOhyb8w=;
        b=WI1GKfMX7KhbjRoHKTKuaCy0aXRbqzDnj0/cbPeJx8ox0dkV/oFZ1zL4m1LMEqWtEn
         qd4EgKwfqY2/2ZmY2lKaGKgp47jlGiQd35hTUtn+v+Ydml998nMkB7U76rGoXjoOZl7R
         8Q6p7Q9+WQPVGgmdEn1QLiyw52J+D0QCPr6o6B3kWmLufMCMn67ftr8C5Y5uryVRcc2Y
         RjjoyToFdMl2oOVbc2cAHDoIm5M/0kxUF9jL5njZ2DKt3Z8OLfZWgfQ2x0L8gFzDDFxA
         y4PvOXxKaAyfFJ6YqJLl4FMrRH7tC+3PDvVhfsmvQFYk5k2Vr+EAbATlJq/rs3cG1YfY
         VS4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUWjOc4IGYo/u8eWLQp7nrqoC2KwYPI5/wakTtVKnkW8v8KuexijSY3rn9y6lMGnuuhZC2sN+iDRyWj6PSF@vger.kernel.org
X-Gm-Message-State: AOJu0YwOXsAaf3ioy373xOkekz3cpXrUTqo8mHLXF9HOFyRyHSRaREwY
	9qFr+Z4GZ2G0wxo1lqljsO4YNWhe97Bw/dspebOUm48dp6TDqrto9ZgLbhzlIMM=
X-Google-Smtp-Source: AGHT+IFg9M2vjj4H31ptfBIKjKvfeR/9yhzgbdkHKDNE/24WihrjrX4qy6Mt6B2DPgOZYyMMZahB1w==
X-Received: by 2002:a05:600c:1386:b0:42e:75a6:bb60 with SMTP id 5b1f17b1804b1-4318c707399mr8683175e9.19.1729758056556;
        Thu, 24 Oct 2024 01:20:56 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186bde204sm37989985e9.14.2024.10.24.01.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 01:20:56 -0700 (PDT)
Date: Thu, 24 Oct 2024 10:20:54 +0200
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] selftests: livepatch: add test cases of stack_order
 sysfs interface
Message-ID: <ZxoDZhpEX_M-vuRP@pathway.suse.cz>
References: <20241024044317.46666-1-zhangwarden@gmail.com>
 <20241024044317.46666-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024044317.46666-2-zhangwarden@gmail.com>

On Thu 2024-10-24 12:43:17, Wardenjohn wrote:
> Add selftest test cases to sysfs attribute 'stack_order'.
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> ---
>  .../testing/selftests/livepatch/test-sysfs.sh | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
> index 05a14f5a7bfb..718027cc3aba 100755
> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -5,6 +5,8 @@
>  . $(dirname $0)/functions.sh
>  
>  MOD_LIVEPATCH=test_klp_livepatch
> +MOD_LIVEPATCH2=test_klp_callbacks_demo
> +MOD_LIVEPATCH3=test_klp_syscall
>  
>  setup_config
>  
> @@ -21,6 +23,8 @@ check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
>  check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"

Sigh, you moved it from some reason. My proposed diff added
"stack_order" here between "replace" and "transition" to follow
the alphabetical order.

>  check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
>  check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
>  check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
>  check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"

After fixing the alphabetical order:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

I could fix the ordering when pushing the patch.

Best Regards,
Petr

