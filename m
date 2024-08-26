Return-Path: <live-patching+bounces-517-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 322F395F328
	for <lists+live-patching@lfdr.de>; Mon, 26 Aug 2024 15:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 649291C20473
	for <lists+live-patching@lfdr.de>; Mon, 26 Aug 2024 13:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEB2185956;
	Mon, 26 Aug 2024 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Eclcii3I"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8252353362
	for <live-patching@vger.kernel.org>; Mon, 26 Aug 2024 13:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724679704; cv=none; b=JXCaaiM0dZY2eLCfMOiKCOROhT7IDFHSZcNSkqS7Nlkn/MBPlLnNRxq753XIJYZAKd1d3RRRIHALH9znpKXh6pCXfw84GY2y2fjsRSncKJ9Rfn4AZ/7lt+LzGi6dViyWzzWUuLy4Yb+D5a/03x1oQoTp5x/OybbwtS/C8yb4UHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724679704; c=relaxed/simple;
	bh=Q/ItTynzx62/JZ3XoUKXF3vsnl0opiQXKjF1CL/u/z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDC1Cfa16N0MRuVKI+J5bfz29Zf1w6uVQy0klf8uY2PVx7fTlIOJafpqxtJAbo2Rayr/r2XT9sVNLRpnFeeW6rj6cpy+ilAEmrk77/YvOZ7yiMM2m0iZkRL8jAj62w65WOUU4hS0do/e/bs8O62VgqWhxSwKV/iZDvOfv447Dek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Eclcii3I; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c0aa376e15so538259a12.1
        for <live-patching@vger.kernel.org>; Mon, 26 Aug 2024 06:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724679701; x=1725284501; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VS0k8aqmiTANe2tnPqYCFrEU6+kNk3H4jcm6bqcbGpw=;
        b=Eclcii3IhdzCGRmw14IxbYm3uN1SSwDYyL1vEw12U9hFUEgXeEatU2vlx1in4jEOCK
         DCXLQDlJfALGufyTnInjvdnl0N4JPqATKPRoXasVVNny4S1JP59G/3ERopzB1OwgD3DS
         ZMLQNBP4kLJ7e78boSCpGN0CsUpJHuH8dB0cQpSP3ndRqmATgtgGtBETGBSH9Bu10noD
         h+5guFQ8ZcNM9jkDUctkIH80JoslbTQq4p5VDeHDEa7DJlGcr3s2xpLegs03TkBbVn7s
         kBZkWpq3GB0YGfa9nndTcrPlNrp0zLaqjhLPJdVQDxrkdZuKm5xudDY05QDy5QfPaHzk
         alCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724679701; x=1725284501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VS0k8aqmiTANe2tnPqYCFrEU6+kNk3H4jcm6bqcbGpw=;
        b=oak5lQn1/QvKnsV5YnjNUNITrBnILJ7Q4zZXI1gp0kBP1HeFwq64lob+5EsWYAbxyu
         jlcIdE4EoGLGZE3TqSPSNYhEkitT7qRavi2Cnx69UML8ta7LQ5ETjX2vQp/hNpyo/b6x
         tocF7DbqeWsQcWd7yMdqfW32wahyj4ZmiqH2jt3KGBRSL8+SpDZplJG9lfFkVVlFY5eq
         k7rNk8cj7uUaUhyQ/hV7+SarHTdkAmzHAnlzLarvx7UuGJ/fUUjf7XJAFOBWiJM2dExR
         pCcoHPvmzv/pIXFoGyX75HqOHHpE2pH0UBW48oMbe7DTswkJSnT9BpxnN+nH2Gcv/eKG
         omRw==
X-Gm-Message-State: AOJu0YwZk0mWo79GAZiOcSpUd35B1+Ko34CrMS9cWaKtWG3g79IHvM0q
	rOAAkMhxDuXEadELeRKdIe/L0rhepZIus9eob/GibHWNVwbDnx0yL4oNGWmkOC4=
X-Google-Smtp-Source: AGHT+IH5lH6WnT3G8aIJDp1bTHZX/1kCI67xuDJkYMM6PFurmYWQZLEQyWU4hlcuav9hrRwlBi0WgQ==
X-Received: by 2002:a05:6402:3489:b0:5be:fe26:dac1 with SMTP id 4fb4d7f45d1cf-5c08915b2d5mr9869196a12.3.1724679700675;
        Mon, 26 Aug 2024 06:41:40 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c044ddbf27sm5668996a12.8.2024.08.26.06.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 06:41:40 -0700 (PDT)
Date: Mon, 26 Aug 2024 15:41:38 +0200
From: Petr Mladek <pmladek@suse.com>
To: "Ryan B. Sullivan" <rysulliv@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org
Subject: Re: [PATCH] selftests/livepatch: wait for atomic replace to occur
Message-ID: <ZsyGEtrMiGTsJkZF@pathway.suse.cz>
References: <20240822173122.14760-1-rysulliv@redhat.com>
 <Zsh51f3-n842TZHw@pathway.suse.cz>
 <ZsiKBlEQS0NsKlGR@sullivan-work>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsiKBlEQS0NsKlGR@sullivan-work>

Hi,

JFYI, I have committed the patch into livepatching.git,
branch for-6.11/selftests-fixup.

Few nits below :-)

On Fri 2024-08-23 09:09:26, Ryan B. Sullivan wrote:
> Changes from v2:
> 
> Adds:
> 	Reported-by: CKI Project <cki-project@redhat.com>
> 	Closes: https://datawarehouse.cki-project.org/kcidb/tests/redhat:1413102084-x86_64-kernel_upt_28

The "changelog" should have been added after the "---" line.

It allows to send the patch as the main part of the mail (no attachment).
The lines below the "---" gets automatically removed when the "mail"
gets applied using "git am".

Best Regards,
Petr

