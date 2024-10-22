Return-Path: <live-patching+bounces-746-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 157BA9A9DBF
	for <lists+live-patching@lfdr.de>; Tue, 22 Oct 2024 11:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8379DB21F12
	for <lists+live-patching@lfdr.de>; Tue, 22 Oct 2024 09:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66CC31547E9;
	Tue, 22 Oct 2024 09:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KBgey3b/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D54C22083
	for <live-patching@vger.kernel.org>; Tue, 22 Oct 2024 09:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729587642; cv=none; b=Q5nW59I6PicoEqqvj41N3orMkqXg7QBt1HL/fvj3LMGwfQR33j95xlN/yqpjYf/KRls3haaqE9owhWlGSEzJDCsRZ2i1lw1NVSTP2PHg88DNP47VO665bMS74AvAK+6PEaS7sbFEN4xBu/B1FVfumJC70DcBKlFcBDIlZierSHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729587642; c=relaxed/simple;
	bh=pAMUEcrcBBsjn/My8edrOsqWlD5Q2CpOfj3OFx998zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUOCYKFaDhDDjSlwDE7hu/W+s6M89+QBBwrw5Cv6q1AeCz4HXA7nqNPp/UZfT5mEUjtYtOvslzmep77T2TVwM5+nBd8yZFBa2raLa39pbfD0gUtvd+GA3IbPThIAQwtVz5wf+8/5K52jhVZvtdizMayqZeqSXAE8nloHZRCYGvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KBgey3b/; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4315eac969aso31930415e9.1
        for <live-patching@vger.kernel.org>; Tue, 22 Oct 2024 02:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1729587639; x=1730192439; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0hFaN/sAZ28IQv/kQdloNCB5hICOmfCsUB3mKiGC9T4=;
        b=KBgey3b/9Qar7Uk3cKT6KNPur8uyJpcufAlborSNqSRIxq7sfZ203o+a9UCbhOZCTx
         fYWRJw7lEHv2g3IQy4En8xkoYvcMy5TX7ETmj+Gi4T60v5l8mCLFcnHa2uC5z66dgmR7
         xLVfFRjqSGxDEPi5h3YdQoY3KZ5T5Xx8F68T9Dq24P0Zo2RIEvHaJzM1qapttzq2O6zS
         fefusX4o/C4n0H2fgTBKG/0S6yNi7fH3ituaqPlsS5MI7lIPDUfYr6Ky1Tn9nPDOBhmN
         zf6FI1shgoE0N4/40F0qvQZRFsoxjBAeZCMbrkdMZwUlKUYVK3di3ijF13shLjwF/f2D
         Hq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729587639; x=1730192439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hFaN/sAZ28IQv/kQdloNCB5hICOmfCsUB3mKiGC9T4=;
        b=WTZ9x2xKO2Fm2/twU9xVjDG4NXUoD9VRZk9cKJJw/PHwwXwFBtmgI/mT8O4Shqf8S0
         PtD4IpB4KAbpOn29o10rApGSeoA8N5YHlGDIEPoiDIuUArTmTpGkhhqThePoXn+jYBIh
         BngCqqEO7K2hJFTU9WpU679ZmdpykSMrlhZ2mX2YE7o6knScE/lsUi+re7miudYQQQSZ
         Q0NHu0LIzJF1A/ioVqiHTQKRSJ3qEUG/t9mRGCtLiVkcY1qGEWY+2FOCPKAWW3chE4oD
         yEAm3QQpWkdup9ZJqw21G7RkKokdY6SMxlXh4xYANQPIFaayW/qM919V8/D0hy5heYB/
         opFw==
X-Forwarded-Encrypted: i=1; AJvYcCUfin278CpvCbV+urcfECVB6Qu1K2Ke0TpE2sD+Ur+xNJFuTdBRHvDv9UGx2gXRYZdMgG5kPTr47tUZkBV4@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/mXdICDVm1kV3g8gkx+AeA9vFjius+ACedyJbeEilBHFVtsI8
	tgG6WfKPnw9dzHJyILZsNY7EqUMn/N0x0LMe+xTeCTC98QJlSyRXAfC0VmgIv4A=
X-Google-Smtp-Source: AGHT+IGBvL9DpIJxEKjzegaN2LTWBJWj4BRs/DC6X3KS+aNbMbld2ASHJC5m+D7+R6fz4Usrb++PBg==
X-Received: by 2002:a7b:c051:0:b0:431:55af:a220 with SMTP id 5b1f17b1804b1-4317bd8e649mr13858785e9.12.1729587638519;
        Tue, 22 Oct 2024 02:00:38 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316f58f1fdsm81759835e9.28.2024.10.22.02.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 02:00:38 -0700 (PDT)
Date: Tue, 22 Oct 2024 11:00:36 +0200
From: Petr Mladek <pmladek@suse.com>
To: Michael Vetter <mvetter@suse.com>
Cc: linux-kselftest@vger.kernel.org, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] selftests: livepatch: test livepatching a kprobed
 function
Message-ID: <ZxdptC2sP8z9wiYi@pathway.suse.cz>
References: <20241017200132.21946-1-mvetter@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017200132.21946-1-mvetter@suse.com>

On Thu 2024-10-17 22:01:29, Michael Vetter wrote:
> Thanks for all the reviews.
> 
> V5:
> Replace /sys/kernel/livepatch also in other/already existing tests.
> Improve commit message of 3rd patch.

With the syntax error fixed by Joe:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Note: I could fix the syntax error when pushing the patchset.
      There is no need to send v6 if this is the only problem.

Best Regards,
Petr

