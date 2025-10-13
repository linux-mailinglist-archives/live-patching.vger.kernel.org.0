Return-Path: <live-patching+bounces-1746-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C3100BD3846
	for <lists+live-patching@lfdr.de>; Mon, 13 Oct 2025 16:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9F6DD4F3FE3
	for <lists+live-patching@lfdr.de>; Mon, 13 Oct 2025 14:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E37F217733;
	Mon, 13 Oct 2025 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XaYIeMNG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10819E97A
	for <live-patching@vger.kernel.org>; Mon, 13 Oct 2025 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760365703; cv=none; b=sTjCdEzVONAI9RD6HfTWJPD2WLHmJFwu8fPQCZPk8DUHcbqSZKIkthrphL9P/ageejBtOvCWokoOibMcMCTa/JaRFXW1OjXZ21beDLJpy3hToc9pT/4kXalfLdWU1jDwWtTW6zgWywS+hPY30tR7NLRodG/+xbWAbCPUUurAQF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760365703; c=relaxed/simple;
	bh=qSDOgIegj5/7OLJprxaVbbB0TVpZscq3uNLHReohDL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdvAQo/RDX/cnD2R8S+UWTLyCjeDpvoS4Nvc7pMxw5bYn4bw4jK4Qe7E+dcRv486ArGdWo4aU46jwflniWxdhF8Pm6I1Z3OaPP0g6ZColnE9JuQeQOwEr04ZM8pL/+CoOx3M+8CL3BKpA9+9onTavrVj2CoTBNsRBA9VGKKBtW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XaYIeMNG; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4060b4b1200so3112180f8f.3
        for <live-patching@vger.kernel.org>; Mon, 13 Oct 2025 07:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760365699; x=1760970499; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C5Wf2L6pRYl1VWb9gXubP9G4VQhPo6XTkf/wwxr/MaM=;
        b=XaYIeMNGWaUgtVrfEHK9RXbqupkAyK6JPiln4+2GcmePr48TF0fHvRzCWLj3/zv31Z
         PRLsfJbO2EnTlSd+UD0HoeN2IIZti1anOjPCG/a0hk2K16r0uqj5AFUyRJlVIxeQwoeY
         hiAzVVSfdd08/3zoTYploLsWVggZUJCUmF7H19BA+HVLe+zDR2R8VHD7COhw73DqPlUs
         Rypi7om5ai5boUK9AgHFspy5l9461mUrmn4FAShnBsAaKGmBl/T7cYZVoj6nXiHcFM+Z
         NdSYLr7bFkx1sGczW9vJ1v4je0leAkEL8jwH/qoF4cqq8bebXqFF/ZXmyf5cDBQ3RSpF
         Apiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760365699; x=1760970499;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5Wf2L6pRYl1VWb9gXubP9G4VQhPo6XTkf/wwxr/MaM=;
        b=GKg3W+0acVYSgFA6LKZmR3t+9DsKsG4FHIDtbWGWFrGMYnMoTjeKw8Qkz4BDDGJ62z
         Ym1FknaqjndC/zdSNgFMLYqJOevcUNHS7E3164PDH1Y/A/1M+++a3Sxnfw/v42dytn1w
         SIglJCCaxThArFl+Yu6wl4DKrPzGAzmX2XxubkgipGl4fpEPuzQKStNlUMNRJ/Wuu2FQ
         oHpavzPLg9wD48iV5F2L+yX6wXw0b+Qt+B5qJoz1zsk+5X7NBtaS37XKIw6bTkTIoAh2
         qrQHFNrXfduEFsHly6b9C6tgyr3Tf09JQ+RnkvO5yHv4sdGFJwrWM+5RXjQ6IdCZPLxJ
         uR9A==
X-Forwarded-Encrypted: i=1; AJvYcCX0Gp2/F7HtQCYEN1l9+p+P9KIWW6Ql2W3zaBua4hrVa0Dq8aHkqoA26qdcmtf4cM3bJ5W5vLRVv3IpTVcM@vger.kernel.org
X-Gm-Message-State: AOJu0YziF28DXb3lyRbIKNrUfEHFlysnR1jnLMkE+YCWruoz7nZH8sz0
	eWrYIdoXDy4pAqXXjFQ5tedbZZFsXgz/eoQksAy4/rCiQMqoerd+3vzMD8xdJHg2o3VPWIhNDq9
	948Ti
X-Gm-Gg: ASbGncv2dQUqQPU8waF8uNzwidA86nE522mSa5LQoVChUscWn4ZXdvW6BvHc/hjeM3g
	qj/cYrrxWo0ZtrnwB4uZqQdN7WswSWevtmr9hauv7/cR924IKzyWjhydvlNLaMlInhG2X3Z+etN
	ZbkMk5xM6OVRKUZIisjW6Zwbcg4jsOGDYkZboaJOoAbx+AhFTOr3YHmq+xNBvK13NAbxh6W4ofY
	0HItkx055dPOiZYahPdWxY+tcxpkbKr/TbU0aqHYsBj9k/FH6IsVWaNI/mUxUBPo4iluxFFu/rj
	xEek+5J2xTwK9f7TPom/2qKohbW+p4C2t2gWcPBWea0MhAaTe2VEoEM7/EehOTkwL4VuYNEitjp
	+dmg3uHT6x5f1zbJcFfGWs154WH8/1xKGHp0fToKYzYx6yIfurkrpADc=
X-Google-Smtp-Source: AGHT+IGNKekYnqITqrySsaLWx5aXn7KMrPP6CFyNtZxLh4rMKjgJfx5OlzNfjh75l7Ry68CnQOurFw==
X-Received: by 2002:a05:6000:2586:b0:425:73ef:b034 with SMTP id ffacd0b85a97d-4266e8f7f4cmr14241752f8f.36.1760365699040;
        Mon, 13 Oct 2025 07:28:19 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb479c171sm188616535e9.0.2025.10.13.07.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 07:28:18 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:28:16 +0200
From: Petr Mladek <pmladek@suse.com>
To: Fushuai Wang <wangfushuai@baidu.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: livepatch: use canonical ftrace path
Message-ID: <aO0MgOhfrMAoPchy@pathway.suse.cz>
References: <20251010120727.20631-1-wangfushuai@baidu.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010120727.20631-1-wangfushuai@baidu.com>

On Fri 2025-10-10 20:07:27, Fushuai Wang wrote:
> Since v4.1 kernel, a new interface for ftrace called "tracefs" was
> introduced, which is usually mounted in /sys/kernel/tracing. Therefore,
> tracing files can now be accessed via either the legacy path
> /sys/kernel/debug/tracing or the newer path /sys/kernel/tracing.
> 
> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>

Looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

