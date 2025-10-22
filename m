Return-Path: <live-patching+bounces-1787-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D67BFB39D
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 11:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D2AC04F7DCA
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 09:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3EF32F2606;
	Wed, 22 Oct 2025 09:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TSEG2Q1j"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DDC310768
	for <live-patching@vger.kernel.org>; Wed, 22 Oct 2025 09:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761126757; cv=none; b=VqU2mAkcJqq1poG5j4Kb6Vp65YcT/dxQHxRidkOZ2EZBZn+2AbOgXXZ6TPlkeVQ7KZTY3wsEJmFmpIxB7tMui30MrtOhbI4TEh1Z2axrNVRd69EL5xjebrqXMdGCrDFmOSR4zMTQcLn3Kw4sb8Ea+qPkKphpm7pS05iZhqUoz4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761126757; c=relaxed/simple;
	bh=u9O+M5FnnOd2ey7mT49qZhuszTjr6/05cfotPdNQzLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEdP2Lt0Eq+5YCBfaAs34lJXPoIzynkTzQxND5SeZHsyiHT7BvaI6SOk/rrl01n5voryUKVTIl5Qkj+8/GoLso6N+pIgehWC82wh97m3pCp6uCdGEqwddqQd54uuSIRWA864ht5XsfuIFlE/dF+pVgdfyDmvhf4ds42OsdkkwJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=TSEG2Q1j; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-79af647cef2so5673064b3a.3
        for <live-patching@vger.kernel.org>; Wed, 22 Oct 2025 02:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1761126755; x=1761731555; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cy2C5yVg52td8J//jTYT9GaB3wcdXgzlUlYOQBGu8zk=;
        b=TSEG2Q1jw1fkAyc3CDUlSBSCbpOHF6Kb9qg5/7FdsXOfb1zHlbV7JRPL0fjkso3XMx
         sHZsq7v/ZxUcDSMbhApbkTPFWuAbErKUTK8+Ngr4eMRhBb7dCcaRKEwiyZk43//DoHe8
         MhY5+T2wU8/Q+Fars2wDhK3tzCWpv7g6Og08g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761126755; x=1761731555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cy2C5yVg52td8J//jTYT9GaB3wcdXgzlUlYOQBGu8zk=;
        b=VayHAjwr5q54C8ysD/VvLos9ov4ce9A4khE6E6CqGMz0wiTFhjdQABDhvycPu49tdc
         2S5h0uF5J3VsnGm6qvEgLNCYTlXz6lyB/YVdY8CT/htRMb1dEvpF9NHa446tkM2DVoaI
         0gQp8g5zG3d6QhSb7xMCSBXO3dqZivK45gqlbAsp8dBdA0mzlMoOXSs8tROj9Ug2O0EN
         rrCETWEa2u1avmmuWCrTdCwN31x61pMLPq/eAPke6kJyDaq/JaJrfiKe5bf/HQDARszF
         IlQ33m2UoBA++zAK0jakjDuLt/m3sPIlsHkt5jvMVmshXYgTTHpTH4Zh5twsvV23BK44
         8avA==
X-Forwarded-Encrypted: i=1; AJvYcCVNHznMqWfpG9AISoeTR2s3XYQpUNAvyIqCL6BbVxWyS6CvmwnxERhlwTunyrhtGkLkxF9NUlC7FG9+deGU@vger.kernel.org
X-Gm-Message-State: AOJu0YyyW0zyCu+mRAzLqHPumzoSEJ0bp9S1ikx7fnNjW16QgQkVZLPf
	i1/UHFJA5K2kYGELHtrxnUe5mDVzBtLCdwR7R3NzYQ1hMM3UrxKq2v/QxOjzV3aZPA==
X-Gm-Gg: ASbGncv8/sp5xRB+TQumsXZESzxRzNeei2+yZu5xnaJCEcxH0LHfFHRVI9k3x1OYZHP
	YCEzAh6eAZ18a9nEDtXbHu36D3kCWTYsnHkGSZ16WARWGbSfCE/MF76W7Wg61VKHx1mtBNkVzCX
	34xhra1WS0Ovo/T5qTd7XGxIJSttTLsVPeATSKc0XLtatFxTEDDaQ6b0uFFPGxImJZgVe1SCJRR
	7ud8DoRgRE1Ij65OOsvCQOwe24sOHxv+Dl+C0HRU8W+ja60UkclLrqtpL+sxXTORq5h/nmnGPpa
	bn/b3F+RstGlMowflEUs/zq78GijwDbhVJ8mMahk3Qgfvak2AW5nLZvBX8bw+RKZIEg0fk1NNGi
	oQZk2QHAce56EBnhkk8yihatQ1SQPEQG3ZWwm6A+F8VrkR35Vmg2d6R7xz6myBFEAgl8gkU1yZG
	fpPDzeo9McX6hqnv15HDxROak4bVuD1SxNGgQppgoKdQ==
X-Google-Smtp-Source: AGHT+IF/TlX3ycQH/AnoCfYDZr7l7J71NtMoNNV43GbWgsSHyZ2FXA9PMcqteZKDpJHEDLLnhDhrfQ==
X-Received: by 2002:a05:6300:210a:b0:334:9b5d:3885 with SMTP id adf61e73a8af0-334a861747emr28239424637.35.1761126754672;
        Wed, 22 Oct 2025 02:52:34 -0700 (PDT)
Received: from google.com ([2a00:79e0:201d:8:5534:56e9:528e:f9b4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b349b2sm12903519a12.23.2025.10.22.02.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 02:52:34 -0700 (PDT)
Date: Wed, 22 Oct 2025 17:52:29 +0800
From: Chen-Yu Tsai <wenst@chromium.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Cosmin Tanislav <demonsingur@gmail.com>
Subject: Re: [PATCH] module: Fix device table module aliases
Message-ID: <20251022095229.GA715916@google.com>
References: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>

On Mon, Oct 20, 2025 at 10:53:40AM -0700, Josh Poimboeuf wrote:
> Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
> __KBUILD_MODNAME") inadvertently broke module alias generation for
> modules which rely on MODULE_DEVICE_TABLE().
> 
> It removed the "kmod_" prefix from __KBUILD_MODNAME, which caused
> MODULE_DEVICE_TABLE() to generate a symbol name which no longer matched
> the format expected by handle_moddevtable() in scripts/mod/file2alias.c.
> 
> As a result, modpost failed to find the device tables, leading to
> missing module aliases.
> 
> Fix this by explicitly adding the "kmod_" string within the
> MODULE_DEVICE_TABLE() macro itself, restoring the symbol name to the
> format expected by file2alias.c.
> 
> Fixes: 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME")
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Reported-by: Cosmin Tanislav <demonsingur@gmail.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Tested-by: Chen-Yu Tsai <wenst@chromium.org>

