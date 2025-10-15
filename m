Return-Path: <live-patching+bounces-1754-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E085BDEAC6
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 15:11:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B6B1189D53F
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 13:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726D2324B3A;
	Wed, 15 Oct 2025 13:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JOI0xuUD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C23630B534
	for <live-patching@vger.kernel.org>; Wed, 15 Oct 2025 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760533894; cv=none; b=lBUkZmpAMa28C9cvA00X8ZXnduzJ1y/pMRsRXjmD9WWaeKZHGEkZdwVAxIpMQol2UaWwfv+QnsvxOAhC9rW0FHiGZx/anmLfRBRQq50w176xVCVYG3QYaHQI7HnFpZZyvXNfDow5Ev9ezT5qfpZh7Vp5LLc6pRsffGy4qJqjHBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760533894; c=relaxed/simple;
	bh=TNN71mayoTkmy8rd0PDSJ9nlu4EsONjvOe6eFy+t5ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bogu55LgZRk+zV3V6YiHsb3RR0xAeN46MklabWETh57Fmtp9ikcT+m6+jfA5SlcLQUC9GIAcj2AuPkkmuljlZwkYUV6Gzv1cY2WP1m40KyRPrlwgiTjJiF+EI7+nn6oly1x3mcep2G+3d2LAxKHzXx91jBQowPvaakCjlGPg03Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JOI0xuUD; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47108104bcbso3898315e9.3
        for <live-patching@vger.kernel.org>; Wed, 15 Oct 2025 06:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760533891; x=1761138691; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KSEXKmipGPjNX9UpQ1OcPNXCLJIBowGxqHQC/E69W1E=;
        b=JOI0xuUD0xScKu7yRljROe3KNMgEatUh2Robg4Dg2gAddZtwlzJaa96bdV/ZCZkVap
         oR5ie552WvYnBhRPG7LhHZm2gPgSYCKcWvPQH8A5SuRFJ5y6DsG66LRxDhuH8XwsHZSv
         u5E462/5bE/CQ9evoUxaMrLZ9K5hCv9WRGwnbqK4/d6/bRT9zGiiwpFJTUvlEzH00HuY
         b8fGUVl37gftDO5FlKsv2SHq/ZTNKcHC/md7rQkXk6O/8FlGUKNq5RtP8aHk641ymllu
         0qYjEU5dSMA1xBei7tOHn4FLEdxMK8TdZ0a/tW/xZK3WxIQVdeNwY+YFk4hWt5QSMg61
         kpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760533891; x=1761138691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSEXKmipGPjNX9UpQ1OcPNXCLJIBowGxqHQC/E69W1E=;
        b=DHVo8MLca0LwzJnfsRQAkdaH/u9hS2/xIRTLW7II0AIWRuddR+Hvla6MMQToDZnmu1
         fDb5vdqJbUt8t7nN9or+3WffrkFZyVtpa3ei+OsWakEolSp+WtDs0T5MannZuRVzfrrO
         YVq8VfT4S5fz96krKVg1zpgTd2hnUC76mlznVB/uvCNVnpIbxzRPrN4+8P7Pnm0zcRvu
         x8OxlZZrm764jki26OiU2eOgdr+uVYkn4LCwvF+LHzmzgZo1Zy1mRQfETtLZdjNhxIvy
         /IkZZq0cnHFOga8aYDy3gZb2rn8+CWcYtzbC0Oee5sNBEXDck7CtXDbbfZskvbyob6ae
         zdMw==
X-Forwarded-Encrypted: i=1; AJvYcCXx2j1XeKbsU1JdZSxdVkPwrKzx27i4doiQQxfAg5Obj6ouUPAPjafdGizd9BR70oQaVODF9pEtF3GdLGk6@vger.kernel.org
X-Gm-Message-State: AOJu0YyJJfj9bdXLyWsJ0b1+j1ufElxewgk4oV6I5FQTahbJMh73knwY
	8e7RUQEywZ5/qxejg3GhWwC7Ik+W8XpiFzR/+uA0Cx29+7dWqSWBtg4PyQh/Wifhsgw=
X-Gm-Gg: ASbGncsR8UW1FE/jXqVqbCklziYRRmVm1BmU4RVc/CIK3aczMAZghOBIxI+bqRJLgRq
	90COBIt8tUSs9DGu1tcZXSaCYe+aXV6U5LJDyxQtcaNl20pRtc50FWkr7HeHo/7qfe80+hfSUFK
	IylUyrE6cPwN8fUXS60LSeRV0sPcuNfIHwmJ6c4sMtB4KchVzU6+7p6PJG/7KQzAU7gSU+JSxC6
	3bWU4xldCBHmjWaJq4Nun0Qf0PWvit9OoSGZ125mVaw6U9FkHLAZGJKQw8lnkTkNrLsirUkr1lf
	nPyCh/CTEjqBUlznPoGpS409wpn4LYoLyJAQfBt4cfJuGnLhVsF3Moj8Igvmy2kiSmatm3slBqA
	7+HA000Y9WSr9DqgXoaqPIVIuoRJLBWuY9Wuj6mkNaI6cdfWi1f2scL4=
X-Google-Smtp-Source: AGHT+IHb7yqFd13CCRX2ZsPulLnmXAv3Os19z37S0V2UZLXAtIujA1Vyw8h33iB673wyOzI9vd+ODQ==
X-Received: by 2002:a05:600c:a309:b0:46f:b42e:e39e with SMTP id 5b1f17b1804b1-46fb42ee4femr110401385e9.39.1760533890656;
        Wed, 15 Oct 2025 06:11:30 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb482ba41sm294145175e9.4.2025.10.15.06.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 06:11:30 -0700 (PDT)
Date: Wed, 15 Oct 2025 15:11:28 +0200
From: Petr Mladek <pmladek@suse.com>
To: Fushuai Wang <wangfushuai@baidu.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: livepatch: use canonical ftrace path
Message-ID: <aO-dgBgwnkplkZtL@pathway.suse.cz>
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

JFYI, the patch has been comitted into livepatching.git,
branch for-6.19/trivial.

Best Regards,
Petr

