Return-Path: <live-patching+bounces-1884-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B7251C9B018
	for <lists+live-patching@lfdr.de>; Tue, 02 Dec 2025 10:59:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7D1FA4E3975
	for <lists+live-patching@lfdr.de>; Tue,  2 Dec 2025 09:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821D0283FF1;
	Tue,  2 Dec 2025 09:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H1vmjeNX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C4826738B
	for <live-patching@vger.kernel.org>; Tue,  2 Dec 2025 09:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764669534; cv=none; b=Lqsss2LZszbLSrZUwkulMHX7s2L/dH5gmesZB20ADDWmISEfYq16fG+0PRHjNiy3O36vzSzgcRV5m2VIeMjTmffwuabSqbT+fnfcoUvrt8bk1EqjPVQiQtHZRE2bnRFWiUl9aCnh18FxinE76bTMMlAY7VD5FC+sYTJ43ewbopk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764669534; c=relaxed/simple;
	bh=JglwWjX+79i5ZzxpJKDVsPCCX+l9dqhFL+TOd4aPbJI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mDB7oi828zCLETXp2kVpp6Uzj3BtaXS3mLi3e7bm9BKbe51Cp7xO/BJej5O/hzdlem4g9bcBp5hJePuAi6DXHi69y0pi3w5gvZpA0pcMwu6ne8sq7TS9Z4GbhzAHV27+lGavPE0+7HsfwNrVqtwMh0lf/TxCarLBwh5LcoXBRcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H1vmjeNX; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47774d3536dso42732595e9.0
        for <live-patching@vger.kernel.org>; Tue, 02 Dec 2025 01:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764669529; x=1765274329; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jb3l4uqvsLOCZ48O6BPN4JLfSyAhOm+BL8PtSGQQtew=;
        b=H1vmjeNXwfUDK2AGmoLzzc3pGm+hLLszFFCe3JWqV1lo1m7GIjqfhxPgAm3kf1FBfn
         0kzh7ZDRKrRRs+tXr1lKQU/Jl61VZgddLrS+zMLv4L+YKcK3yGtSTlLpep6F80B3HB6S
         tK/j5E041da8hTd4L9VG/fGkjhMVz2uBxZySWoTWRbQpxVgjj5DM/hG4aFajezvNqept
         fLgGMDbE+TKrwGdzz3L52SvGHVxFiFQFit61hKSGRVNComdhFTZ3ER7bqXtNd2jb/mD/
         PpW5YlbKCQRFWQs+jiyzytJFNMVHvgmWwPrW7wEoDVJdLGbF0nUdvZTSEdu4hpD9QqMJ
         jJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764669529; x=1765274329;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jb3l4uqvsLOCZ48O6BPN4JLfSyAhOm+BL8PtSGQQtew=;
        b=lb7Z/x7HXa5KA+7x2QWQ652NuDinoj35gRT7RGDcX6rPlqiXD7dV7icT9gJd4UlPC5
         72LWzLQ+J3NCuNb7F+fNdd1hjQ82kvZBX6T7x8/jpCbfoHKqoxKqII1O38oW3KRes6h7
         quvy37GUmsngaxOdE+ewkv4Ms43HskKcE+94Jf4UjEthb0kJbcqoUteNw3afvOHR1PPo
         f1uiix6pCnLaSAYho82OVNmgBA9FgbSXLqeHgmTEw0RXqimv/M9ev27mF/XCvvtjb7UU
         PIM4AuscTrXtr9Ou1CeZubzJMBHkbFx64iRKJUvjkGDTX1VRxdO1wJCPdMQ7QF3H9JmL
         lLKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVT4DPMmcyniX9vop2XAy7yWWne1G4wDrDL87Ubqxf3For0IN30cHPuom6RXBZ0hai/sURaJfmORZu3QKzP@vger.kernel.org
X-Gm-Message-State: AOJu0YzF52zpJvtT2AHXJQ6A6PbuibqevIDHaQcvB2qZhPwEpgV+ukKV
	5dfb3ALObRXR/vA5qykB0EACZyDJoTYiOUXmyAEjZ5ART40VQUrdU9kYRr9ADjqBNwk=
X-Gm-Gg: ASbGncuAV11P3nyAsJNipyiATN1FZC7NKhqWpKU99qHmtEbm9g0gE/flqw/bwSRubwQ
	iOiS21xBeWkXiPMVdtwjsQHrQp9pNAnVAvE6Za+wJsoRwUkRn0WkhzsJKA5eZy3HwDQOq3NFW6K
	ZnHbJ7RCYOyCQqKngGodQ2aY2Om2bCaxPcmU4tcWjyqtlStzR/tAdslkHf7QNKNaW/wtqqVc5O8
	QtFxTUNSftLXDMGJvtqTGOvRlHM6+5C2u/NzSDbvAQeu/FtbtkVoqkSgz34EiPl5Lk6y37Gax/8
	Jl9p50Y3qqMRpO5+tyzQ1We9tCVNsWo2XnSye+sy6t0kZLte5UTz3qWd/7ee+FCYfVdWdr2ucjF
	CcIW2qz4vQdB0q+q++nV0YkFvJ0pk3wGr0HVZ+Jfsm+0MkbuxT4FNFVA1XTLvvqGvXypU08bMiE
	qef5z5DuSW3jMJCw==
X-Google-Smtp-Source: AGHT+IHMneoaKJ2kkQ7WN5BiNeYd1dKd/fXalPonV5+0C6PCNFu9bPRPI6pjup1Kx+S4lR5TVlY5sQ==
X-Received: by 2002:a05:600c:c8f:b0:475:ddad:c3a9 with SMTP id 5b1f17b1804b1-47926fa069cmr19642915e9.13.1764669528743;
        Tue, 02 Dec 2025 01:58:48 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4791164d365sm287301955e9.12.2025.12.02.01.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 01:58:48 -0800 (PST)
Date: Tue, 2 Dec 2025 10:58:46 +0100
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.19
Message-ID: <aS64Vrv7L2ZfVkM9@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

please pull the latest printk changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.19

=========================================

- Support two paths where tracefs is typically mounted.

- Make old_sympos 0 and 1 equal. They both are valid when there is
  only one symbol with the given name.

----------------------------------------------------------------
Fushuai Wang (1):
      selftests: livepatch: use canonical ftrace path

Song Liu (1):
      livepatch: Match old_sympos 0 and 1 in klp_find_func()

 kernel/livepatch/core.c                        | 8 +++++++-
 tools/testing/selftests/livepatch/functions.sh | 6 +++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

