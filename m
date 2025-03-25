Return-Path: <live-patching+bounces-1333-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6DBA70320
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 15:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4527188F6F9
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 13:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95AE257458;
	Tue, 25 Mar 2025 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ajWv4Ohw"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7012580E2
	for <live-patching@vger.kernel.org>; Tue, 25 Mar 2025 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910989; cv=none; b=JF6CUZipylUPoOm8Ry7UtSV5tOaEIHEaXBEAS6Yg2NCLMiAIJhr0i1Tz1J24mzWTZX8VjC66F8YRi+ghE9wdyLPnSMVASp14nuc55yXpJhVpRzjlFtEmOKlJUggqmPHAUV9+od+7STQe7+3KAPavcNtTEHEm1nCRuraiusb19HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910989; c=relaxed/simple;
	bh=A1Q+B2gufMsfREQp5SIVWcC7720Z/T99tr9MbQkNLgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHje8+pGzZgFaktWeOqld3fw2sT3BMDMqB2CbYBwEzZzG8IvWqYOZY9y1C3qDCLTCXZqQupbyGDzzuwjCXaKtvFaybLXTd+AcDWPzwGGhknM79cI1D4vBL7ACdauL/bC6UKlKkKu4wv2T9XMyBhiUf24ePW+MoVnJJTGukMgs/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ajWv4Ohw; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso4099316f8f.1
        for <live-patching@vger.kernel.org>; Tue, 25 Mar 2025 06:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742910985; x=1743515785; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UenxoH6KmmrH5CC3OQgIopnnTp23ZO/0n/qWbM1/1zo=;
        b=ajWv4OhwFXIiyIBoxfRqNRV/2qs/SZUnb5D19ez7n8slAjmmQf3L57Wh8xjjywnKPe
         hJxu8GOT3IejCy5pYIqeFokINlrWCk0xex+XUUzEIl+uoLgTmy1NuKGDa554zFCsSvfH
         QPUjhFBtN//YwbfEdRxl1gyB+o7UHTBhe0M3lo8SEmqJpueBk21iQevFgueZueTOTP4k
         cbQDf4WK1eq9VShlE3WHwyDxecsbcI08j5dV/WmOVaCV/nuy0NeA1Sgj0mSzhkG4fH0T
         LZ/qO+FGFT5td1mm2dHhwxlGBiSKDIhroiaEyuVxOlwGY8JqsOSFc4gyr7ZtcNDnznGA
         cbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742910985; x=1743515785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UenxoH6KmmrH5CC3OQgIopnnTp23ZO/0n/qWbM1/1zo=;
        b=ZW/FykyZzCRFr+gpitOHDCQjejVX42i5rFTaATQbBRNOyCyLrDEUQgkURY42G+hyb1
         sGctW87zz49Mu85BLuEnP8toRq5E9RkGZA6utxnYRnDLRhD7ve65ln2S0OXZwXVU9uh9
         TTFdJFr2aPHTsjzZf6ZwIleJkXNJHI/vDmHEn3a8gjZ+du3oP03BlQxOlWSCvSVoBHLO
         0XC5GMk4f/DG4IauxPOown67TlcqQJTk14068bG0RSGgwGyqBji8Mb07mk+JZrvuoJbS
         D+JxaMEkCt56+hNWntl6Ro+IlXk9RD1xg8r2baCNqxf5xug0/44a6Y8tDTdIDn7xkbDQ
         Ib0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXcU28M9Kci2bdR5uAwM8pbDMmqyN/wX2qGEU4uFnFlOk6tbo+AcNox2fe0iJzIwQA0zvYwXiYmG6w2eYou@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+GLfFbR9wJZKyQrPcuAgyhNOIMJwjkRRnUWC3xznEXNTFZVVo
	cqRdi5mA0HzQuOjVf0gxHJsiXAp/RSkL2tebXUQ1b7Y9eOEB1rbb8gCcoRLi/iw=
X-Gm-Gg: ASbGncujLYUBDMlrqMCry0qyTQusxIHgPJoxyvATCQ79mQ6XA8uSvsN0biWZJYmfne6
	AbsPIJujM081WYHUrPbnYd+EFHsLzBNuuxQCZ6LhOm575m4R4w1ApGGsRRthYY9N5TSJONSdco3
	Wh8HTSGBFUc1vE5OdH9llXSZzSt2VCqw96KzgAEd+tVkJ/BZZ8XtnSAH/u7eVAFkpcb2cCFIc0k
	+crF0aaKsNLydTh64rlvNEsQygaDg6W/DBn81pHuo0Xre7ZAzn3I59eA6cvWiz9XwQMWxdpOGf2
	6URf/yyu3J6q7ND5T8agM8DeEPFAqa/1zt5FmM97NzK3
X-Google-Smtp-Source: AGHT+IGuP7hdX4oUt/uYmCs7eqmCWfVYFgG4WOsXpx3j+wCi9SZrdUfRY084MJJ+0RZbPCxY7u8W5w==
X-Received: by 2002:a05:6000:188e:b0:390:dec3:2780 with SMTP id ffacd0b85a97d-3997f93c60fmr13164520f8f.24.1742910985169;
        Tue, 25 Mar 2025 06:56:25 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9efcb1sm14030721f8f.94.2025.03.25.06.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 06:56:24 -0700 (PDT)
Date: Tue, 25 Mar 2025 14:56:23 +0100
From: Petr Mladek <pmladek@suse.com>
To: Filipe Xavier <felipeaggger@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, felipe_life@live.com
Subject: Re: [PATCH v3 0/2] selftests: livepatch: test if ftrace can trace a
 livepatched function
Message-ID: <Z-K2B8WMVf36sLcX@pathway.suse.cz>
References: <20250324-ftrace-sftest-livepatch-v3-0-d9d7cc386c75@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324-ftrace-sftest-livepatch-v3-0-d9d7cc386c75@gmail.com>

On Mon 2025-03-24 19:50:17, Filipe Xavier wrote:
> This patchset add ftrace helpers functions and
> add a new test makes sure that ftrace can trace
> a function that was introduced by a livepatch.
> 
> Signed-off-by: Filipe Xavier <felipeaggger@gmail.com>
> Acked-by: Miroslav Benes <mbenes@suse.cz>

For both patches:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

