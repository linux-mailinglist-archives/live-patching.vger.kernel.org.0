Return-Path: <live-patching+bounces-1079-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D154AA21803
	for <lists+live-patching@lfdr.de>; Wed, 29 Jan 2025 08:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D32F165B5E
	for <lists+live-patching@lfdr.de>; Wed, 29 Jan 2025 07:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC26192590;
	Wed, 29 Jan 2025 07:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3PfbrpvD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA39192B85
	for <live-patching@vger.kernel.org>; Wed, 29 Jan 2025 07:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738135429; cv=none; b=l0nDU8I42coylvpNN1R/SZ4geEh3GK0Vkfzn41sfW8ZDXyLCRApZPKc1qMTEmAYkxGQMxAcWY9HNprAOLkuZat/yzcBWsRJF55HEG6yvHCLylqzGpORnR9FIwtamv5K6zCgix06ny0tpDtvU1gpQwXoR/YQ3qKfNHdYhp6nV/+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738135429; c=relaxed/simple;
	bh=to5O8NoTB/c/DDyXIccxxNZqz1dxeSJFdLztzKRAPko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zoyqo7FRH3m9SCxNyZq2Q/hA8B4/lglHUgr+EXcNGM56z25LY88Ppr9D71nzCyiqG/tMStZ/7PvM45hBxXRARpIXbJ+vfkZp36zSDqkutQmsaq0+oJq7hUWt+Uh8LlVWugMFOPVZnH0O8z7ryZcOnsLCjplcA4mQo0cta8GTZ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3PfbrpvD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9dbeb848so12216097a91.0
        for <live-patching@vger.kernel.org>; Tue, 28 Jan 2025 23:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738135427; x=1738740227; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=to5O8NoTB/c/DDyXIccxxNZqz1dxeSJFdLztzKRAPko=;
        b=3PfbrpvDaRzsZHdX2XNU6Yxb1pAGM0OkvK0MHRnOLTYrSWqL90usiCZdKVTlFm0oH4
         ZfXCCdaG8ZSHlNT3OxVJRZVfe9iszZHjAhsyHVV/thqKDSFCFBB2v/aaIVZNIdaPuafU
         J6F7USMNyR3zQkmM0+waaTI5q2eb4GDAfpsaVHdpts4AQi1vrF5QfAVm/z1JO6XuHhYa
         SWMaIDznYYS0XiO591Twvmn8DSvsEwQNojhRmGMJFFcu8xq5yiecivhXVtn8BV08kQiz
         nrwgPT1HznHDt1Vi/L3kBB390wPn1crgRN+ay6f99hfF+Pbymh6t26jFFqMsTVNwOYjy
         Qnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738135427; x=1738740227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=to5O8NoTB/c/DDyXIccxxNZqz1dxeSJFdLztzKRAPko=;
        b=YEGdu4maNgx1qnP/azTEEoLnxAZqoRLGiUjR6w7OY40h1vcV5aDBDv+5GO5bNYQ4VR
         yfEPb/8bQhv+TE952rZERxUPZ0J5WtT4tz3IHgv8OkGi884vNA3ML5UhosfEg2msTK03
         DwkwnyFGpLc9g1b0a38K2uKxjAgNa61fz419S1KOG5IKjXWa+rMkejYLHEX0rzMUDVv1
         Jt/AM9KM+Oi2cyPD2l4cq4E0x3bqtwIbXVBr7Z6JQMfw5ZUXmKlIH+SJ4YJmaRUQkFQ7
         9vD0lQCSZKMgmXft2oxc+2rrH/GCeExfcp3xPZl2ZlnWYIeT5O9pH10lV3CH0PZN687w
         iHxA==
X-Forwarded-Encrypted: i=1; AJvYcCXhrXBcsDF2lClFpODSiUQ+ogxfGplcgYRCNjzHw2Bfz8OXYVDVyK+hsh/EHKzkmDzcBt3FoISZv4083leX@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy/JNi4NcMO9rylWOipB3VT2Axs7mag8j1dG1Ft5oaQRBiwlB8
	YdNkIg3Pjvv4UtsyYufYC6M8NyQGlbWfi9ql1ncUYs6iQ9fw/x643sbR9/VIVBVw08Gp3HeaIQ=
	=
X-Google-Smtp-Source: AGHT+IFKzhN6yxa1m0w1DuTS6hG3IIPd1uDcWGcK6u2GkZ3C9EsPnGf+Bhi+qQWDKgF+BnewqutKH+ggrg==
X-Received: from pfbay42.prod.google.com ([2002:a05:6a00:302a:b0:729:9f1:663e])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d8e:b0:725:cfa3:bc76
 with SMTP id d2e1a72fcca58-72fd0bce05cmr3286318b3a.4.1738135426969; Tue, 28
 Jan 2025 23:23:46 -0800 (PST)
Date: Wed, 29 Jan 2025 07:23:45 +0000
In-Reply-To: <29b94227-8861-4011-b83f-2e0c59dd1f73@oracle.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <29b94227-8861-4011-b83f-2e0c59dd1f73@oracle.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129072345.3106495-1-wnliu@google.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
From: Weinan Liu <wnliu@google.com>
To: indu.bhagat@oracle.com
Cc: irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
	rostedt@goodmis.org, will@kernel.org, wnliu@google.com
Content-Type: text/plain; charset="UTF-8"

Not only does objdump show that func_start_addr all 0s, but the
func_start_addr in the kernel module's sframe table is also incorrect. I'll
prepare a repro so we can investigate this.

>
> I can share a fix for 32589 so atleast we can verify that the starting
> point is sane.
>

Great! Thanks.
This will be helpful for comparing the values from the sframe table with
the values we obtain at runtime

