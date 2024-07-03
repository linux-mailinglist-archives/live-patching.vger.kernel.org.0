Return-Path: <live-patching+bounces-380-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C41F92555E
	for <lists+live-patching@lfdr.de>; Wed,  3 Jul 2024 10:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD0001C222A3
	for <lists+live-patching@lfdr.de>; Wed,  3 Jul 2024 08:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E341386C0;
	Wed,  3 Jul 2024 08:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cVdKgAKA"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6715613B586
	for <live-patching@vger.kernel.org>; Wed,  3 Jul 2024 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719995451; cv=none; b=gT25BVl4mNGjBsEHOGTGZdPn6RqIa4tJqwuH0HYL5Ao4zlbkV8Pghyj2ZJ5N2pxrqbQB/Y4OLrD7yytySVHl7Bi8AIURdg8blLzuheDwDXtICUoBfaKn189CFkBk62N4fgfqzm7FkLItCm84+E5foSfcpyu3yQAmH0S28pZC0Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719995451; c=relaxed/simple;
	bh=lyDOsVlLtiQWgXFPLegFrf4IMjukc5O6D0/Va3PMXN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5EjP2qVYij4Gl3vkXlu+drYJqe7GuHseJ551huoc0h0tGSU9CHTbMM7yLnMWuL+iBPZl05gQLmTp1K1aETAMCISIzws/zi/4PO5fz3KrYx0j1DJuScfgxvydP8l1lqtAW/wkbrgWYNSTX8YWEaAp3t5stcqZJXI1uczAa8hCvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cVdKgAKA; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ec1ac1aed2so60309861fa.3
        for <live-patching@vger.kernel.org>; Wed, 03 Jul 2024 01:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719995447; x=1720600247; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DWUUsvaRIlmVTXJWVK6NrvSZu1OtSTfBbXLR9cvya4U=;
        b=cVdKgAKAxSuyrqY4vitRwfK97rzJBNvbGridXGMc45hCtd/xBbYKp0Vw4trF9SnYUr
         C7LhxnM6PMQVA453p0tacLxpclJZQ4fT09z/GWYMKCdj8pSqHlYpSFtx+8lPeL8oVO8b
         aUudtmeLMVpCj2SxUW1yEHP8Amndxomy8hO8VZ5kUkwwfweCp/LYyc+wWYk19rA3GwBu
         1IAcK4PhbEBQxRTUvqZR35uKvVIGnaBou1phiZsY1qBtWP53CfoJiwTjwMtRG8xa1u6Z
         7ksdShVLi6Wrg7lxAf2PYglp2ZOv54HNhjWhTm7EZtCcSbdmLaI/ps9M9wXUdKLHB2fp
         WtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719995447; x=1720600247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWUUsvaRIlmVTXJWVK6NrvSZu1OtSTfBbXLR9cvya4U=;
        b=tXUajN/QMqLSOfZ94LKn+q6NeJnFO3PVkJ0pyj7m4QCa+MzzSjtxW+0arTjW5mMQED
         eczFZww/ZhjQQbVIafa9gn5kmNu9Tod2jW43WN7M02LCd7aeHhCAHtgxTD/XORU0Nxob
         J45viw5uS7g5+zb02pP/3FRFiEkJiYYuOzoQ5eoTK+bYdXAQkrehi2bfB1TLWQMry+/W
         JcnWI2BnCDMBVwqrUiI6buI4/9WLyXTpOZXPdkyhil/QjxSaCRho24nhAN4+O/PQZaK3
         /UEUtiHgtFqvFAZaH3xHrY3nkcVBoKOoRyAvlXTrho4qqoVf+JTbKDGZ19wB2utSdH5K
         7R1A==
X-Forwarded-Encrypted: i=1; AJvYcCW8jJu3B4ZMPCu2asoCb2JqdX1TEGkh61eBeZbEH9TnJfTf3Vn2S7logmtcoTyCFG5H9Z7cU/9q8brGYSVugpekimYxsNXCDF7pV25ISw==
X-Gm-Message-State: AOJu0Yy0eX2zOBgLnfHpiDTh6r3goUnZX4URHTYMBhuPKbgZ1Cd9I41b
	+wlk0su4s9f6f0QJrj3Jc17OtKqBscuhz8nq3g95NqLWE0/gDwWbvQ92nGUHayg=
X-Google-Smtp-Source: AGHT+IHg9Z5qTCSn1V4Voifdtej6R23gugYxk+cky/iJDuuLpi1H3FBa7p0Mrk/t2MoyUChu3mRMhg==
X-Received: by 2002:a2e:8e89:0:b0:2ec:568e:336e with SMTP id 38308e7fff4ca-2ee5e37e0cbmr71475701fa.1.1719995447484;
        Wed, 03 Jul 2024 01:30:47 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91ce58877sm10246154a91.24.2024.07.03.01.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 01:30:47 -0700 (PDT)
Date: Wed, 3 Jul 2024 10:30:38 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, song@kernel.org, mpdesouza@suse.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v3 0/3] livepatch: Add "replace" sysfs attribute
Message-ID: <ZoUMLm02OnHG8g40@pathway.suse.cz>
References: <20240625151123.2750-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625151123.2750-1-laoar.shao@gmail.com>

On Tue 2024-06-25 23:11:20, Yafang Shao wrote:
> There are situations when it might make sense to combine livepatches
> with and without the atomic replace on the same system. For example,
> the livepatch without the atomic replace might provide a hotfix
> or extra tuning.
> 
> Managing livepatches on such systems might be challenging. And the
> information which of the installed livepatches do not use the atomic
> replace would be useful. Therefore, "replace" sysfs attribute is added
> to show whether a livepatch supports atomic replace or not.
> 
> A minor cleanup is also included in this patchset.
> 
> v2->v3:
> - Improve the commit log (Petr)
> 
> v1->v2: https://lore.kernel.org/live-patching/20240610013237.92646-1-laoar.shao@gmail.com/
> - Refine the subject (Miroslav)
> - Use sysfs_emit() instead and replace other snprintf() as well (Miroslav)
> - Add selftests (Marcos) 
> 
> v1: https://lore.kernel.org/live-patching/20240607070157.33828-1-laoar.shao@gmail.com/
> 
> Yafang Shao (3):
>   livepatch: Add "replace" sysfs attribute
>   selftests/livepatch: Add selftests for "replace" sysfs attribute
>   livepatch: Replace snprintf() with sysfs_emit()
> 
>  .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++
>  kernel/livepatch/core.c                       | 17 +++++--
>  .../testing/selftests/livepatch/test-sysfs.sh | 48 +++++++++++++++++++
>  3 files changed, 70 insertions(+), 3 deletions(-)

JFYI, the patchset has been committed into livepatchining.git,
branch for-6.11/sysfs-patch-replace.

Best Regards,
Petr

