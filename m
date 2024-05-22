Return-Path: <live-patching+bounces-285-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC528CC07F
	for <lists+live-patching@lfdr.de>; Wed, 22 May 2024 13:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2939F284106
	for <lists+live-patching@lfdr.de>; Wed, 22 May 2024 11:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E51B130E24;
	Wed, 22 May 2024 11:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f20xYOjL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8F412EBDC
	for <live-patching@vger.kernel.org>; Wed, 22 May 2024 11:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716378276; cv=none; b=dh2rp4bR5PAW9e4Ts+u3yEuZ5wuQJLn0i9EgSHzxwnHv8uBGy53OWm9l9sTd7JAVq4bRZXW1J1BoPuFIUg8kp53EtBv+lfsI5JmCaTOs9fJX9d3cepB9QdSH6VpUtHUUnfOA0Q2M2E/yzMv0ljumCN2UepiqO1TpsDuKOtYdjdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716378276; c=relaxed/simple;
	bh=LpnRNcJij0yq/HxvAH4NrOsBgPjXV73gGgD3lrbBeFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KShhRAgTVSGOwNinkLYfobjQQGZ0k6jNbyUKAvgji7J5VdnWyD6ZjXjTXj4RSOZ/Bv3PECt1tHuYpTOxYBomOKMvuy9cpFSSxRQTX1Cb6J5YFveLnAGIv2ygb5qPFF03oFdtPzQ6Og9J8Q4bIRqLdZvnlWMl+ii6CtKqW+kCIng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f20xYOjL; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2e6f51f9de4so67069601fa.3
        for <live-patching@vger.kernel.org>; Wed, 22 May 2024 04:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716378271; x=1716983071; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=voS8iBC/CPfmqha7lxiV2JBUbAAWG1gJ26sqax7yLe8=;
        b=f20xYOjLwWwoZQ2vjy2vQpiKvFK5HJ1E1GmFEWFgELk+HuWiujYJRV02yqVXMGAqCq
         cJO0UISh2o/j9udiybFmRT/Nzqjm74Of1aBZzcwy3rDa3/QY8nvpj+yXC96YGZgZ5aXd
         /UGGaT/gZXvoSuW/Slh3JSRe2iJU69BvedXeDTT6Sw0DId1qlYkTRNNYW/e2RDhT95cg
         gbNCWtyDbaIckDtW5wgtRV3iIospmYd81O5Q4QYwm7X3UDK8AhlIfMDKh/Vp0LbhbO4p
         Yg9S7CVYSB5ckXRDc0nXKwhfuMaBpTUZ0wXECGbIKII9f0XMRuPb1uQFpPkH/T7LEvSQ
         r//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716378271; x=1716983071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=voS8iBC/CPfmqha7lxiV2JBUbAAWG1gJ26sqax7yLe8=;
        b=VEAcKAdnt2gHk72UsKgkOTbliqX0trsUGD2fIw49Hr1L2K15nexJWfG0VFh+prxvef
         M4hCpD9LqMk4SkgqvHdAikt1LHGuqwUF98aAP0vT6jxA+TZGUN9EV3P2HFcyqhlYy+/H
         X+x2L29cBw2xALLSgn42ihGBV+98DZU5u8oG8oQDCM+cbDnxhYjwktPmmfSd228DxRTE
         uQWWNCpe+5/wpuBg1ljVxXZaRZptKk91D+C31QP5pFSY87pDNVduF1KnOcXXRKzgtbnH
         z3EBrr1QWJP0mYkN9+srYiT15ipC7BI/+hwOKIorr8n6y43CebmGQ/cQ8mGBhFwshrTX
         GmOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRROy1JcJ995q1BOE/af712808+G5dSWYC7LHuOsSRv4qr4NbaywxMAmcwPZYKrcnHYVXFJ4i/QvfMYJpAOIKGuR3S0uoDDzvIPPkxAA==
X-Gm-Message-State: AOJu0YxhqQnS8tbQ8x7uJRgKX491R48KDdQZR+LImn9euscc417Uemly
	dFwm8i+JWk6I9N1avk3AS0Bsl/mYVtMdFfedXehwDi1e9kFkpySToJK+GrdifLw=
X-Google-Smtp-Source: AGHT+IE6UsVgyNWxEj1Qq4n1+brostMB59DhOJ0AltqQqX31WU0Ago4GOZq97qgQ7AygtP3IFrRPug==
X-Received: by 2002:a2e:9210:0:b0:2e1:c448:d61e with SMTP id 38308e7fff4ca-2e949466c14mr13483761fa.15.1716378271019;
        Wed, 22 May 2024 04:44:31 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17892450sm1778426066b.63.2024.05.22.04.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 04:44:30 -0700 (PDT)
Date: Wed, 22 May 2024 13:44:29 +0200
From: Petr Mladek <pmladek@suse.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: mbenes@suse.cz, jpoimboe@kernel.org, joe.lawrence@redhat.com,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, mpdesouza@suse.com
Subject: Re: [PATCH v2 6/6] selftests: livepatch: Test livepatching function
 using an external symbol
Message-ID: <Zk3anchjqeCkZmU5@pathway.suse.cz>
References: <20240516133009.20224-1-lhruska@suse.cz>
 <20240516133009.20224-7-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516133009.20224-7-lhruska@suse.cz>

On Thu 2024-05-16 15:30:09, Lukas Hruska wrote:
> The test proves that klp-convert works as intended and it is possible to
> livepatch a function that use an external symbol.
> 
> Signed-off-by: Lukas Hruska <lhruska@suse.cz>

> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -7,6 +7,7 @@
>  MAX_RETRIES=600
>  RETRY_INTERVAL=".1"	# seconds
>  KLP_SYSFS_DIR="/sys/kernel/livepatch"
> +MODULE_SYSFS_DIR="/sys/module"
>  
>  # Kselftest framework requirement - SKIP code is 4
>  ksft_skip=4
> @@ -299,7 +300,7 @@ function check_result {
>  	result=$(dmesg | awk -v last_dmesg="$LAST_DMESG" 'p; $0 == last_dmesg { p=1 }' | \
>  		 grep -e 'livepatch:' -e 'test_klp' | \
>  		 grep -v '\(tainting\|taints\) kernel' | \
> -		 sed 's/^\[[ 0-9.]*\] //')
> +		 sed 's/^\[[ 0-9.]*\] //' | sed 's/^test_klp_log: //')

The prefix "test_klp_log:" is not used anywhere. It seems that this
change is not needed in the final version.

>  
>  	if [[ "$expect" == "$result" ]] ; then
>  		echo "ok"

Otherwise, it looks and works nice. With the hunk removed:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

