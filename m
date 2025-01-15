Return-Path: <live-patching+bounces-997-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF8FA127F7
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 16:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50D10167542
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 15:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EAC158527;
	Wed, 15 Jan 2025 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cNYlCxOi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C22624A7C4
	for <live-patching@vger.kernel.org>; Wed, 15 Jan 2025 15:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736956632; cv=none; b=Dc7JDojM6xih5l3FoYddJco0sooq9diIAD7tF0PhaQa7rlWHoi5t7jB6pzAuqIWQGqU1aVmWYW0Z5enn0AE9/qLwkm1i0AlaVTEAv6GE/GfmObZKxoGVoEZNZ7e68j/ALXoyG0mWeNKPkca/UkvkGjiWPdFUUVue5MW3VL8+Q2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736956632; c=relaxed/simple;
	bh=xjbt0OvMA7EHXtFjfP47gzti2AhgAYfUD5JcHd0gxKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktEdFegMyeyHoUQC3O3QoePPF3XMeCzH8DbE4vM1AEzg1F8Kqg2zDZwOimwt/lJxymfyT/A8gvOSKZpBb+dROwyTXLMPoipEjcPTLxK4cCViuiVTTvW7M/Xf2ZuIn+/QXa8tShCo+X3+AeULcp5sx3Otg91fjGJJZfwexMMCGL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cNYlCxOi; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3862d6d5765so3669823f8f.3
        for <live-patching@vger.kernel.org>; Wed, 15 Jan 2025 07:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736956629; x=1737561429; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zO8SCDpb1PBc0evM90QDpIHT2aXA3uul1RObWQ/WFw4=;
        b=cNYlCxOiizAQBgaN8fMXJOxF9sk1pA9VaB9Ph201qZHY/7uXeDQwdyIRKaZJ4cYv/3
         SBrKUc5zGhPwlLo3REbyflp75KWVQgWafMKA0bVlE1nLa1YnPss1Xt5bcKDCwFHRf1lh
         zMQTxgMr1Re/6FbRN55IHYtKIjL5ZJs+GfytBCmxFaXXMLHYNJDL05CFxVcrB3UgbdPY
         4M3f1PT4J1sZreDMzyCPLHfFZv06CLQYDjaooVXGrMSWJ32dvxXC1PsIWnDOv0yrCaR7
         RNlGmMuGfOcdELSrBWt07rXKNy6J6kd34L2txYp1U3Z+YWs88pCAfa8hsKwJQaPtj7ZL
         /45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736956629; x=1737561429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zO8SCDpb1PBc0evM90QDpIHT2aXA3uul1RObWQ/WFw4=;
        b=FJ6IOqabYHDSm4Ila0k4hAFvfT963VbUXzLjdZPSDsCgaisO0ZKbeBT7hEtUzZ9oWZ
         VzNz5apb90kpyw7mYgGWx7G6UYGKUa0fkB+kfem3ONbmx77RWd6EaPO3kBPv927U7qba
         L/fQI94c1gM2kEAJPL6ltvhfkvOnsQlfKgbYhHTRcdkSxscJ9EbP2P2lF1nGsvsONYod
         0NFTYX6cPjUdPJy9AXJRLiOdM2yfGWGTnQQcZ7sUBvdi5j7/9nQv8MeiP2coCrLI5xUL
         8fa0kGykuv6TExKL6eMA9VefEHn9vYs13eIAqIvkc7Nevpjr+6Q4DK+simphjKEjO5lk
         nkVA==
X-Forwarded-Encrypted: i=1; AJvYcCUxtvsbz++BnHRYuJsixVEpVlmLRnVT7z24xyDUMD/Ximvv/2rj1MhC8FrFG7+w40cR9imn9iVOQ2/yrgqu@vger.kernel.org
X-Gm-Message-State: AOJu0YzIjNr6hJmujzfl3rEVFmXA4j7epLk+7Xc3uhZ/mqG78JNlQZsb
	w0KtJTVm0MFckKOr4HSuLjPrFbEtPbbxT9aEixipVXgpAHpI9b3Y9zU9hs94WC66UfuxFvVH6+/
	u
X-Gm-Gg: ASbGncvYZvtw3jPdpigpFE41KkZnAoq7wZapDLNqeYB1F4PdhPXSFc/5rp2lnYL4t9I
	jcHrD6e9H7LgR0OkvPE28ANV4PSDACsTaF5ciHuxiPr+mBadSGcNZjz+Hi6n2kZBtczha1Dp9P3
	MWFF96Q/vK6fy+EWc01AArWuDjavJMFN9wb5t1mcZ0PtV+lTkPdxU7yfaFKLl+YuUkIkRwp8UPT
	65c4I63imPDyNcuqEepiKHLc0uzZFgcO/m4hCx8GsCHIqURtJ0YaqD9/w==
X-Google-Smtp-Source: AGHT+IEcnR6Tnsd8j9q10IR/Lptj+DuUFWRk6nIXTRe7O/CtJh33Ud22yUyqXbWWro1ge/gLeoJt/Q==
X-Received: by 2002:a05:6000:154a:b0:385:f6b9:e750 with SMTP id ffacd0b85a97d-38a872d2affmr23995936f8f.9.1736956628670;
        Wed, 15 Jan 2025 07:57:08 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38325esm17880527f8f.27.2025.01.15.07.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 07:57:08 -0800 (PST)
Date: Wed, 15 Jan 2025 16:57:06 +0100
From: Petr Mladek <pmladek@suse.com>
To: "laokz@foxmail.com" <laokz@foxmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: selftests/livepatch: question about dmesg "signaling remaining
 tasks"
Message-ID: <Z4fa0qCWsef0B_ze@pathway.suse.cz>
References: <TYZPR01MB6878934C04B458FA6FEE011CA6192@TYZPR01MB6878.apcprd01.prod.exchangelabs.com>
 <tencent_D03A5C20BC0603E8D2F936D37C97FAE62607@qq.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_D03A5C20BC0603E8D2F936D37C97FAE62607@qq.com>

On Wed 2025-01-15 08:32:12, laokz@foxmail.com wrote:
> When do livepatch transition, kernel call klp_try_complete_transition() which in-turn might call klp_send_signals(). klp_send_signal() has the code:
> 
>         if (klp_signals_cnt == SIGNALS_TIMEOUT)
>                 pr_notice("signaling remaining tasks\n");
> 
> Do we need to match or filter out this message when check_result? And here klp_signals_cnt MUST EQUAL to SIGNALS_TIMEOUT, right?

Good question. Have you seen this message when running the selftests, please?

I wonder which test could trigger it. I do not recall any test
livepatch where the transition might get blocked for too long.

There is the self test with a blocked transition ("busy target
module") but the waiting is stopped much earlier there.

The message probably might get printed when the selftests are
called on a huge and very busy system. But then we might get
into troubles also with other timeouts. So it would be nice
to know more details about when this happens.

Best Regards,
Petr

