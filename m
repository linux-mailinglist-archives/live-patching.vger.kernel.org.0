Return-Path: <live-patching+bounces-353-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B84590C879
	for <lists+live-patching@lfdr.de>; Tue, 18 Jun 2024 13:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2E2A1C22A1B
	for <lists+live-patching@lfdr.de>; Tue, 18 Jun 2024 11:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908C01AC790;
	Tue, 18 Jun 2024 09:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MpxSbLbc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110D01AC789
	for <live-patching@vger.kernel.org>; Tue, 18 Jun 2024 09:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718704333; cv=none; b=VVS6giy3fCNivuBszoggJFL5ApQ20rfW+prvadsjaC0MfFuOdhwWG1wvyR9gujcX9kMn9vCn2hAdOjPcHWPQzB1P8I1jjUn5Y/5MkKGg7HSEksQr+2wL8ZSAe3jGh60aKSPtdHofdATnW2FC3cH2N7y4Bep7bvMyn1qsb7AmzVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718704333; c=relaxed/simple;
	bh=lpstofRG73uDVk1Z/6guZiSclMY2OFnjBUOwbBpQQok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsKiANKBuBo64N9obXmDnwNyWpoQeQdSelLPyNf7tdsPAks4/QQRWo9FLIdjnI8V7gF7KbQHBXvCTjZIKc4OMpElZbdaft+wfdB80sAx5N1Lvv6VQ+2ISMhFupgKC4CI1y2e5ghCJ2/lDFtCOvIpAgZV+NEFin7ObDKWIZNDvDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MpxSbLbc; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52bc27cfb14so6481972e87.0
        for <live-patching@vger.kernel.org>; Tue, 18 Jun 2024 02:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718704328; x=1719309128; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MLKpOAPm5+5EAsIFns7yv/QxPTfttBblX078jzEuTPs=;
        b=MpxSbLbcjSv7dLNlZFbWc4nKBXum1UzzH7X6Rf/AaGaGMhhFnp0CxwSdDrASb58msy
         /Y3UNBd3mGFQBLYJ8AYtvz/Ub+QYehAvORfUqlWD8Przym+9OlMd7ACOzxZ9Mz/5D62N
         yqsiQEFQlsMsGbJlBIJA02q6VxyBbYZi5x8HAxp48dVJq4MJi/Hi3wGUU7j3YFIPEzi4
         XcDo0VfMCDrGQnbVKm01qQVQW6Fk166Lx6utglSN1NjOjf+DJHJV9IqgkTfaw7R56LDp
         bk6UIujtKlJFABElN8Z4sB98ZIDeb9zZm73RW4iSk6Qg0IghkeBKTm5T+k6sCbUdf/Ds
         wDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718704328; x=1719309128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLKpOAPm5+5EAsIFns7yv/QxPTfttBblX078jzEuTPs=;
        b=H/mdWm+ME2KfURAc9h3CIWUZ2wjsXNvFz1uGniR4jNl7uq1V5YK+y2sV2z+49CzmVD
         3Adk9YzW1NV7CcomGuLszglzE3oxEHfwlcdulsTzx8cxMj7mH2kClOZtKHNuPj+mcwiL
         BKweML9BlqJLqL6NIH9s75FSN8sZOln38lhHXA9J2riUuchmFkqu93j83WbUo3F+ew5S
         TCaB4PfLhbj43gjb3R7hMB+XhZaE+wxp8yWL0b+7LvEQt8CbdGXjmoEzuOP/EOpxOaOd
         C5pFVZHORLLX48IuDdOZn3yQz1lHV7jVgi7NkwBOk5Nrq8bfBUOPAm5kCfMW7rlNwCNa
         lc7A==
X-Forwarded-Encrypted: i=1; AJvYcCUPg5Z03r0+tdNdD601BxLAtSOjC52ajXV020CJbJOcjtupRAUEuAxUKW8jH74BLWnLL+gwcHlSFkm7C3dW/CXaaMZ56L4FHBSg9qhM2w==
X-Gm-Message-State: AOJu0YwFGx+aNSl4HGXCAIiYNmY2Utfj/8bSKK8cQ6sDV9dba4eU93dB
	vBajNrlG5qk+0bgd0AIeEBL9e8WFau5mEQ+izyY/Vh86y+9k2wcDQRWAv8pg2hA=
X-Google-Smtp-Source: AGHT+IE8Ks5Gv42HRh2TCcFWfJCLuZfM37uk5Vb6/c9+mGJ0pB6v4kY9eJ8v4BYixiUCLEhQFme3Pg==
X-Received: by 2002:a05:6512:3984:b0:52b:fac5:a3e9 with SMTP id 2adb3069b0e04-52ca6e56fc2mr10158452e87.9.1718704328119;
        Tue, 18 Jun 2024 02:52:08 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f6b2b04f5sm453640866b.192.2024.06.18.02.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 02:52:07 -0700 (PDT)
Date: Tue, 18 Jun 2024 11:52:06 +0200
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests: livepatch: Test atomic replace against
 multiple modules
Message-ID: <ZnFYxiWXvE7dq6Et@pathway.suse.cz>
References: <20240603-lp-atomic-replace-v3-1-9f3b8ace5c9f@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603-lp-atomic-replace-v3-1-9f3b8ace5c9f@suse.com>

On Mon 2024-06-03 14:26:19, Marcos Paulo de Souza wrote:
> Adapt the current test-livepatch.sh script to account the number of
> applied livepatches and ensure that an atomic replace livepatch disables
> all previously applied livepatches.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

JFYI, the patch has been comitted into livepatching.git,
branch for-6.11.

Best Regards,
Petr

