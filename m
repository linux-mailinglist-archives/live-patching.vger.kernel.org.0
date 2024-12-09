Return-Path: <live-patching+bounces-881-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6899E9E9046
	for <lists+live-patching@lfdr.de>; Mon,  9 Dec 2024 11:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23B812819CB
	for <lists+live-patching@lfdr.de>; Mon,  9 Dec 2024 10:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F555217F20;
	Mon,  9 Dec 2024 10:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IxP4kqr+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22213217720
	for <live-patching@vger.kernel.org>; Mon,  9 Dec 2024 10:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733740430; cv=none; b=KyMZL9yoF9KucQ73KCtWqrDgUaHDPdMPhg+7rjYpgnFIiPQJPmheRwWxxvPqyGwv9GE+3fmE/pphuu5Arrt3sbe8p+iQcHQX1F7oQgsFYn8/loSRHQQVdK88Lx1MwIeB5JUubfFcnXik0UmEMS4KSiH24ViBgcWHcg5uGDDXcfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733740430; c=relaxed/simple;
	bh=hGUNkPAiGXqDSa7dT0mfVI5e/Of5hnaQwknDb+vS7nU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GgM2SjO7hsFPi+5grsFWa4qdvXG1Nt9NxOZFAbgstGUmV22oY7aRFiG5G3PB+UMAl9ucWmr7EKDbSwqUy0tHbM70XFz851J2fvIUhzFeBlSYKXYH03g/DzLyLL4Wtl7L68GhAFF3gwbfJOynOGpxOkcBHlFamECHDyKIoBvUkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IxP4kqr+; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38637614567so789749f8f.3
        for <live-patching@vger.kernel.org>; Mon, 09 Dec 2024 02:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733740425; x=1734345225; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aO4nLx0kfH9s6VR/jADGyHU7Uf5zkyJtN7uAkPweYn0=;
        b=IxP4kqr+knA05dewRXP352kR4vz/uQ92QRo0hjAZcwY6Y0gVSMdurW97o38J7nKz7x
         sVmGTnbJgJCL5EZhQHePfzk0FmfRzA8pEcGwnyxWzLxqoIEN0MGTK4EFJ+lu3M6EgKDn
         +YHRvl5Xq2btDL4J1H6QiFIV77EVTcWqM94lqaZ6OQav49EZ3i8Y3ni3KQfsMQGG0p9v
         PL5GtCTrAW3ayTmJzpOF7EVnGGJyYt959kzDkMyRmWiymAi1ErFh2Wcqd6p/ezwvgxFh
         MYwFy0JqAaldsCThAOlCoAsRzWCZNpbR43nsMSl+IuszkN9jZ/pCrV2Cb+Seyu5HSTBG
         A3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733740425; x=1734345225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aO4nLx0kfH9s6VR/jADGyHU7Uf5zkyJtN7uAkPweYn0=;
        b=qyUufq1dSqDxOB87/aifsgW3csfTDq/97y71n407cqjm4woVaFNUkonD+4NPa3O+k0
         Z2QnIDGXvcIUiXiBXsI1QziMJJvnWoniQAPLDsorkuef7U+jcM8wT8xjG9nk+vUTNQVM
         eOyfNZe7XcskLsxS6oK0SlL8yU+kELAER7h3cqBCJkYQcCLXhPsD/KOIFM9x2OYMy1px
         uBK4GM1qB8b2vfOUhlf4smS++vPEDEyax2B1VgCSICHnYFR/tA1ExJX8fmf8QH1zAqDy
         YxgWLO/hRG7/SWpt/BiqDtkg6W28gYLvXjFCOe8yVuNBsCYTSP6XWkduGSoI+U1KsVTX
         vuHw==
X-Forwarded-Encrypted: i=1; AJvYcCU7B2AV+qbasYvIBH0Up6XpFHLkoli7jebM+9oKOXBUllCLokllfNw2TUXeWBlmAqcX5SexLzhfYJeDHJGX@vger.kernel.org
X-Gm-Message-State: AOJu0YyDaJI7tUtQJ3TdKEUEhf0v5vm59pkk2ChdTxaMsLilLz+7QPQu
	yUBlJmKubUT1Ks6La5Gj3VjhCYPzRGdu3F0X0p0Zr4hOt1OKAmcmMCWkS/jTaWs=
X-Gm-Gg: ASbGncsHh+03OPXLktyzSqjoXT9MzDjzbGChtJ3Xy3XbtQCPe5Sj08FuR7V6QRAGhBn
	g/ZzpIicM2qRmEeJVIEDYXPy3PCdDGebaSjmQ5Pxr+zllOYfZPM0uze2+pkQfI1DOBUFCFE9/R6
	0IqTZs81YTBejwuUQZry4bO70bmKYRR7ToI/aZocXBtpxORDUFUcXTuKNtLoY81/EkS2oLO2ZX0
	9Sz3xzDsu979pb8tSOLQ+NO1EsuMjvfZ+R+Eyxm7umAqLYqBmo=
X-Google-Smtp-Source: AGHT+IE1Mq2p1wEAoDyK2ADS8QG2njkoPsV/DcaIyc6/bJSThV8qrxTzCj1DyCksy6aEjoZIpmshjw==
X-Received: by 2002:a5d:64ab:0:b0:385:f17b:de54 with SMTP id ffacd0b85a97d-3862b33f3d0mr9798912f8f.5.1733740425377;
        Mon, 09 Dec 2024 02:33:45 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725f3e936ffsm919093b3a.132.2024.12.09.02.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 02:33:44 -0800 (PST)
Date: Mon, 9 Dec 2024 11:33:36 +0100
From: Petr Mladek <pmladek@suse.com>
To: George Guo <dongtai.guo@linux.dev>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, George Guo <guodongtai@kylinos.cn>
Subject: Re: [PATCH livepatch/master v1 2/2] selftests/livepatch: Replace
 hardcoded module name with variable in test-callbacks.sh
Message-ID: <Z1bHgHlMuc_H3L5R@pathway.suse.cz>
References: <20241125112812.281018-1-dongtai.guo@linux.dev>
 <20241125112812.281018-2-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125112812.281018-2-dongtai.guo@linux.dev>

On Mon 2024-11-25 19:28:12, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> Replaced the hardcoded module name test_klp_callbacks_demo in the
> pre_patch_callback log message with the variable $MOD_LIVEPATCH.
> 
> Signed-off-by: George Guo <guodongtai@kylinos.cn>

JFYI, this patch has been committed into livepatching.git,
branch for-6.14/selftests-trivial.

Best Regards,
Petr

