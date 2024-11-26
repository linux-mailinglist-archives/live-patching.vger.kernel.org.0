Return-Path: <live-patching+bounces-865-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62EB69D9809
	for <lists+live-patching@lfdr.de>; Tue, 26 Nov 2024 14:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21DAE160FF4
	for <lists+live-patching@lfdr.de>; Tue, 26 Nov 2024 13:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393A21D47B5;
	Tue, 26 Nov 2024 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gZ+nKnx+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66781D2B13
	for <live-patching@vger.kernel.org>; Tue, 26 Nov 2024 13:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732626524; cv=none; b=bAed7uljxRg9VqnryVWNPshs9xJtc9lPY3ew/aEflO0sZf+r8l2GcxrGIfGM3TybAPjdcAPkopraLNf9Bg34hUYlvOHnhv0NL222JMttvn1+J/s5dRJv4oObAGD4cWNUxQgFT700eCy/v8DgmD8rm1raOVbIup79Y7uQPYpbxsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732626524; c=relaxed/simple;
	bh=jQHJQQidNbNUcgbt21fubMe8SqP8NtfERFhpsdEmuDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSAScVIl81GxM3a9klrNDDOkrgKf3PY0oa1mbF3bpiN+eokJnXi22S0b0dNawOBXN4CL+yxeyZaceJX3PA0K+AdL4tCGOFJenWYg0HwPUFhdPnPm2Gll0Y7gu/3pA1Hku8wiyX2CnGM5GebYxsP85JifCrFcq81DKqXhhKTME6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gZ+nKnx+; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3823cf963f1so3514549f8f.1
        for <live-patching@vger.kernel.org>; Tue, 26 Nov 2024 05:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732626519; x=1733231319; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EU1FFuJWDKogHlWGs2wUOZ86NdWkE+VHCPjkTaTPb5o=;
        b=gZ+nKnx+1JrqlIN7NIpqKzAByijs131QXGQ7YJlRjpcGFusOakzqfOZbBdZTHfkMOh
         RdOtsX6SbnLvrYe3DLyJIT+NW9xqYb12/uX36fWYtvlpsWnL6faobVozkwcBwD3LYfVJ
         OuxciqndSn+LoepGzFfTGeEMtmVXAe2QXAyUYV2SMz+bDLAtcGu2b3MXlhOSWAEvENdw
         K/JJOwzVOnpbbejKBrUAucvNvk8+zinzYJWj3I0Stor1Z9vbqAqBsW/QoHt0AE2oIvl4
         tbDy1JbvROKjyfLO/bQGs8NJ2lOAMuk5mSZEh6m3mKKuKOZs0WzxWEH1/M7Zy+nQ2L5Z
         EjLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732626519; x=1733231319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EU1FFuJWDKogHlWGs2wUOZ86NdWkE+VHCPjkTaTPb5o=;
        b=LZdapkZKrAYDcoEYGrbPKvt9JzA+kaHBzvaHQ0cBWg69P4GPjc4sVCrSONiVFBY+2y
         5hlMxSWa6G9AY4+vRr9L0XuH2t+r9islS2gwwkLDkoxzhAp52HGm17/ej1+DAq0zoLmO
         TqfOmY4Iw+zZFDkoRR6vVv9uXXrquerpvZAx3G0PquUJyd2v2Rf3PfKast88/Tx+GvjN
         IWBsdaI4cYjpQPfO/PmHVky+MTyyFqKgW4fFcWa2PlBmHR96VgfomLKNObUhrU9EkQ2Q
         BZKGsR/ZZmzODvI3CFY3pVmTBG2E55Gc7/j/4Zx4cbyUsNSd5mSWkv32jDNNsW3o4yRQ
         e0AA==
X-Forwarded-Encrypted: i=1; AJvYcCUPm5Gd7vOC7To3iVVQayBhHsggT2SMnzdNE3mU281bvkXj3cCG5Krht/jTmMNmVACkvguNZnx57ZnJWVtt@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9jjTscPacg1OyAtwG1868oLrYn6XqcZDiPqlRT3MRJ3Pz+EBr
	urxRaJSc3BsC5+fe2lSEQp+ik1TqtQNebmvOS8NjcCf+xWN+Qs9wwdkvNXb7UDI=
X-Gm-Gg: ASbGncuJy9AFAz7O+P+mjftSkPQmKmL+aQAteAevXzXcMUKJHiNWtlnUayM7f7ZVgWH
	sPxbCJ+aWD9flJ9Edtyazn1Bix8CyNGtEd8DcYblboGQJD/AGWrES4wiiASY/XTWp+CH5MHH8of
	JzX+1Kx4od1LSqLLPBqHUIJe6k4xsIf8CYtKOwFI+s8PRawf9SqcwotZMVoXBSpIgVWAm2XIlDo
	n88M02g81R3AHLXxKnl6viupQTInMFYuCu+RTg186HpPfU7Ul4=
X-Google-Smtp-Source: AGHT+IHIHEiY4LNIwECV9uQMLGLQvbtYi3+I3aK0yZuOUqtailKy9apEj3gRf0AYBQIaYBa4yUIKKA==
X-Received: by 2002:a5d:64c2:0:b0:382:2a2b:f81e with SMTP id ffacd0b85a97d-38260be4aa2mr12232395f8f.51.1732626519211;
        Tue, 26 Nov 2024 05:08:39 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fb2683bsm13438746f8f.48.2024.11.26.05.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 05:08:38 -0800 (PST)
Date: Tue, 26 Nov 2024 14:08:36 +0100
From: Petr Mladek <pmladek@suse.com>
To: George Guo <dongtai.guo@linux.dev>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, George Guo <guodongtai@kylinos.cn>
Subject: Re: [PATCH livepatch/master v1 1/2] selftests/livepatch: Replace
 hardcoded path with variable in test-syscall.sh
Message-ID: <Z0XIVBrwRJMB594e@pathway.suse.cz>
References: <20241125112812.281018-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125112812.281018-1-dongtai.guo@linux.dev>

On Mon 2024-11-25 19:28:11, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> Updated test-syscall.sh to replace the path 
> /sys/kernel/test_klp_syscall/npids with a variable $MOD_SYSCALL.
> 
> Signed-off-by: George Guo <guodongtai@kylinos.cn>

This has already been fixed by the commit 59766286b6e54f8ad33
("selftests: livepatch: save and restore kprobe state").
The change reached the mainline last week during the merge window
for 6.13.

Best Regards,
Petr

