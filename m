Return-Path: <live-patching+bounces-1859-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD06C600A9
	for <lists+live-patching@lfdr.de>; Sat, 15 Nov 2025 07:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id A07A724111
	for <lists+live-patching@lfdr.de>; Sat, 15 Nov 2025 06:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9291684B4;
	Sat, 15 Nov 2025 06:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oZBCBhAl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D32B7B3E1
	for <live-patching@vger.kernel.org>; Sat, 15 Nov 2025 06:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763189429; cv=none; b=dWsgnNxOiNEIrPBRfBz+R4dma6UHufjBjY9yp2UoazVQaDLc0XGj+jrEB+mnk7+Hzk4BhriG+QD1ZHHkjliJa+iBt5fmMzzZ5eQAYtT8mdjiYArz3EYKalq/zJFIm3kkjuZBOcsZVK+gxi+kXYzhBa9mIchP56rUfjZ4i+KpOYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763189429; c=relaxed/simple;
	bh=2tW0LyD7lPDFPyZX6hBWfhUMFiG0xJGmNujgZofpES0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KuGqbLHn7cmGFbn9sJqZICHPDyfDvcLJMgh6fk5PdhHWTBXgJLulCkqLWPTvAXZzEBFmOoNpjb1N/EVOxCsruVrUCmT3MKazaEpLo/HWup+mbZCp2dsaccKPpTLYU8do5CuI6O1wG603qyOVhatPt79SwFuYi/u9neuNs6KVv78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oZBCBhAl; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-93518a78d0aso1382958241.3
        for <live-patching@vger.kernel.org>; Fri, 14 Nov 2025 22:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763189427; x=1763794227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tW0LyD7lPDFPyZX6hBWfhUMFiG0xJGmNujgZofpES0=;
        b=oZBCBhAlXAzIC5OwCtW/SWZ9k0IFPRL36WB/aFvtur9NJLA8LYxEVPe69hOBiKL96w
         83csgIrFJmKxbSwrF+PINjDXMNBPFIqwZZxk6bzYMfxeiyN48wPAHtW1QTBJhZZjDjbu
         aviduhSOe5ez0laTFbbHuuvC7ZZXKQU3GV+xisCkNoMQSwh9vx9hBcZXPwhWzDeKPGPH
         E9g1lwTbTyq1eHluruGz9dhRmy0D3RV5irWKCM5FoIx5Mh/lbHJ9bywqxW84l060hoL8
         lriP3jq2zuiIi0G7H8kdS5+z79WoiGCKcr0E4o/wjcwwuCdiKsPn90hu0LJu4j5ufwIs
         H3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763189427; x=1763794227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2tW0LyD7lPDFPyZX6hBWfhUMFiG0xJGmNujgZofpES0=;
        b=XMmZLbrbkY1PVAaohdm3ulju+yElGI2PSo1SvnANKahmNgISwVwOuNuuyL2YWDMBB2
         TTjJ+cGuN5qUQW1eWPpzSEwVW9NENoWoi4QZuHao4YPJE2/cT90hR/a2K9zqedfNl6o3
         LRo4scrGk7MDn44njHF71V5VqE5zSaQe+1OQrUxmj+7EQNl/ocHnArDJN0emLz1ve61S
         HcOnVfDtbrEorbVwT2rLFlNW16ALA4jn5m6zHkFO59Qx+wq2i1G7RhKT2SOARyGGKdI6
         zjx9MFljt0NH32j4TJDk5Ri7/6V0JozrFyKWh0Gc5CKyh7Q+jHKYMcv0rEAu97EYnK84
         eYpw==
X-Forwarded-Encrypted: i=1; AJvYcCWikO6eU1PV+jtd7ZlGSMg8HozAQi4HfPc/3jOX8wvRH9OLJGkF4vXaU72O/B+0Kej8hfaoTLYeJvbt9Dob@vger.kernel.org
X-Gm-Message-State: AOJu0Yymf8PFQWPAbZS7IVxRn7c2Nx4T85fAxE6L4kWXedwRVpndpaaz
	m5GjnlzmoCqmp2bYWlK+xgbNlKYFzuRRc7pVZKivmu48BQJiQji1pYrgZXrvHwOE0CFce3Ft/c2
	0U+uyePryn8+3T1NiSs+Z7iS1rfhNEJneORjyzU3n
X-Gm-Gg: ASbGncvjaDfsjs5OyIxVkzZWDt38of3OmmgeuBsma1WJXYplCa8tx0lv6IAfL/BmwPy
	5bG9X/a3OkYaelC+vWNkXu2SGRErgvDTRgD1nfGG29x5EfRzWrxtSyDsnksJwyfvjwqY8e4M2mv
	bdlLK6EbFj9eJM5WTKs9tKViLcpVOr9pgeWzY+FVcvfaejakgvTu1isyv4xMeC1pcdYNL72msXL
	AmcXtzitb46wCQZz/Ed38oTnD5lOODgabrp+pWpyywaahSb+Kx85LyJwBXE3aMY9tELgBo3Nc35
	uo+HrA==
X-Google-Smtp-Source: AGHT+IGBmG/bz8wPBiYtxku5DZxZIFswqelN7iIVhJMlsnxcwBAOO1VRybnkMu1WBNFjmuaiSBfmOpqiqWYlPZy+7nw=
X-Received: by 2002:a05:6102:cd1:b0:520:dbc0:6ac4 with SMTP id
 ada2fe7eead31-5dfc5503207mr2436468137.2.1763189427035; Fri, 14 Nov 2025
 22:50:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com> <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
In-Reply-To: <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Fri, 14 Nov 2025 22:50:16 -0800
X-Gm-Features: AWmQ_blGVgxRBfC7-R23y0T7-3-YKsOX8wvdHW6nZuqIavlU7e5yux5y2ewLCbc
Message-ID: <CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
To: Puranjay Mohan <puranjay12@gmail.com>
Cc: Song Liu <song@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2025 at 12:55=E2=80=AFPM Puranjay Mohan <puranjay12@gmail.c=
om> wrote:
>
> I will try to debug this more but am just curious about BPF's
> interactions with sframe.
> The sframe data for bpf programs doesn't exist, so we would need to
> add that support
> and that wouldn't be trivial, given the BPF programs are JITed.
>
> Thanks,
> Puranjay

From what I can tell, the ORC unwinder in x86 falls back to using
frame pointers in cases of generated code, like BPF. Would matching
this behavior in the sframe unwinder be a reasonable approach, at
least for the purposes of enabling reliable unwind for livepatch?

Thanks,
Dylan

