Return-Path: <live-patching+bounces-660-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0075B97A45A
	for <lists+live-patching@lfdr.de>; Mon, 16 Sep 2024 16:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7600B1F2117F
	for <lists+live-patching@lfdr.de>; Mon, 16 Sep 2024 14:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77B615699D;
	Mon, 16 Sep 2024 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="USxARtL+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F6B3E47B
	for <live-patching@vger.kernel.org>; Mon, 16 Sep 2024 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726497847; cv=none; b=D0HtOkhh28f6d/8pNSkLgztRJvNrHfWt2LjYI2yNHCR7hUW1oCQ/ln+2ys9yCQMItjJjepYxq0XCzNohJxcWQQzhpVM3i/QwqUjcU90Ra/ZfnviEox9VA0zmG2wHYdj1gMvaffgX50Bngmw6LencES8L5LHd8cdSTeRJRLJ9LGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726497847; c=relaxed/simple;
	bh=Ewk3TLXnCpNI+iFuOMwZOsVETr/FOvqodSwSIESD6CM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eWPdODGFkMplGFjIhbj3t1ecsyqqjEGYTMNvtn0ogZCyiMJ2YUTd6T8LrGvjbQBVi8LXOh8jcRHB2KHQnI5JYXhFT+vc9L1hv+3rP/MDryoAtycL6w36A3+Dp23RnM+wPWLokqYFY2+MvhUK/39YScSyzjIDWZE09FDBqP1wW8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=USxARtL+; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3780c8d689aso3427333f8f.0
        for <live-patching@vger.kernel.org>; Mon, 16 Sep 2024 07:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726497844; x=1727102644; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=of+zQqXun88QZo4C2kqE6fMMTayqSecJNXPWXYIMLPM=;
        b=USxARtL+CH8RoNPOoOE41+vnYFn1nPRIV3OwEiy0SOh/hPsxTPeSM32ZhazzoRM6bk
         8twoPTzUR1aKJy7cAVmC+Y7B7F/vBDhHpr/8YYGBILtBbIXI9b1sYLMWex5e0ZHvYKTn
         BK0jViBJnGnMLZJmkdbQuu7hpfDOTQp8vF1yXyNuB4YVMi05WTSgPHLVEPizn14IZF4U
         AegFTswfnRBMlV/PqkGSONDqG09e4F5F/yQbeVo6E8/ePEI7SXODd2dxIMG26C/LHuk/
         +lKe5VTTvTj5PF5nl+qfACOG56BsyA9brRCEAxuNl46LaDDoxPIRfJpEDTt2QZpAoEdf
         uRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726497844; x=1727102644;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=of+zQqXun88QZo4C2kqE6fMMTayqSecJNXPWXYIMLPM=;
        b=qyBcGXvIT+vfXpkNCz2R8s+TszId2bq2uuTC2V5ZCAK3G2P+juZJaQGDzi2VkYXezf
         MkBhxH2CGYqEls64laeYjlSbEi2E+47m49BzSIvCwp3LZwd/A3p8eTRpTarkFN22QX+/
         ZxRPx/bAatifddWMSeqjWHjK0V7uA5525EiptLyW4uMUKyJV4vaTbQCHuX+68/3KeOW0
         4kj6bWeXrdcVcu7sW41yiFph7HjsOyCCJZwcmjYdt7DwIb0oTWKv7NIDV1vd6mQJRA32
         cQzMBPkFTr07gqKNl77pbE2swh2CY9miwGPUw+UvPZ7ysBvXFjS9wA4IjK8tjJviZA8T
         leWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWOiiO95VBdsrUAww5PyMpkqvhLIdoyI/c1/9KYNEUSEc630F4KGvQdPReoNy8ghzwoOrpKRVjD8Xv7azy@vger.kernel.org
X-Gm-Message-State: AOJu0YzNwgPi3ZCstrnKdNRwah3bEl7Qxg29zseNbbN5OPqIsQwyj7id
	gOUr2jvnX76ZdsS0OlZgjDCy351HZ0DZJ55lP86R1T4eADQTuNh0kmvuRmuu1Ro=
X-Google-Smtp-Source: AGHT+IE7uH9HI38FaIBfrRVeek7PbiDkU9l+qzM6HpI7Y+JxaDT7QOZ2DcK7U9/xatJrF9LYeIt8CQ==
X-Received: by 2002:adf:e94b:0:b0:374:c69c:2273 with SMTP id ffacd0b85a97d-378c2d6987amr7932346f8f.37.1726497843881;
        Mon, 16 Sep 2024 07:44:03 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944b7afbasm3781611b3a.135.2024.09.16.07.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 07:44:03 -0700 (PDT)
Date: Mon, 16 Sep 2024 16:43:55 +0200
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 6.12
Message-ID: <ZuhEKz4pBXuNJDgX@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

please pull the latest changes for the kernel livepatching from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.12

=======================================

- Small documentation improvement.

----------------------------------------------------------------
Bagas Sanjaya (1):
      Documentation: livepatch: Correct release locks antonym

 Documentation/livepatch/livepatch.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

