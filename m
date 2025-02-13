Return-Path: <live-patching+bounces-1181-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A183A33F54
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 13:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C906A1886989
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 12:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F93A221561;
	Thu, 13 Feb 2025 12:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J33K9za5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59B6221541
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 12:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739450451; cv=none; b=C4w8H1y7Wfyq39xfHaLCHsiKvsdbfZUeb894wJl4qCGpIEzyUsvVJiNUU+PuwEJ3z4FVpcyj4tMt+AmgAdbZF34ZPppVSwS6R05bfqkhZqP4rnt0jyRRTr1Lvw9QUGYvR24VWUOZ/cxAD5UofI6y7FU96kiJfH7CMo3A5VdQ9bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739450451; c=relaxed/simple;
	bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=EbM3KbAKhqCK9Q63ikaQpe21A6ZxXZNR+qAfxrBi+Xv8D4ggE565o0fVuSUkGOtW8PDLpQffIFhz0z98f5tKMfndcpU94q34g08EUKcz/yDOt/gp2g72CpcuvSBjW+W437RZFfBraZeaMBW6pkn3Gbj5ww6aRE1jO7mATAJRh+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J33K9za5; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3f3bac262f9so487848b6e.1
        for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 04:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739450448; x=1740055248; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=J33K9za5UCr7TRsnamnzJ/j+GkczDSFRZo6iUViW/epDiz+sAWhUzBX+YibzKI6Znr
         dNg7hQw5nVyd1BJ35thW/MIPcTcfLV6qyZRTXe6XSGjxOnxQhTK+Nab7YkUxTlixH9ic
         CTFxF8HGQrkZ+SHWpCwGe8wliRoWK3ivDPneRW7BEc4bmXJkexKRDmzXcQ5jE2HZRzLU
         LEs+wNrfOHZbzVzAAxNjLGMxX4Vbtvkl+YTYklXDgckLkBtnoig5lvIm4mGp687APTCE
         mbIWWstN04WczdEG2o9TmquvjKIdxUGOEfOoqfPzdkQn4kKQnZbgblh1nBWDGeC+MiV6
         5EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739450448; x=1740055248;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=EmTOBuElncTZPpElSCbY4YbUNEbDeYwAtwLXYG7ZxYxc8RcOO+L0/HBSF3yUrsyVFX
         5zUkkGUQc+Gs8OR1R/2hQAUl6uOfGpV4PxHOfOtvfR5N9AjdiQGTB8yKDflGHeNe1syS
         8q9SQaMfS82R9q5wNVqY9KK+6Jd5/FU7/D9iDh0tSOfRDrE2sxQqbCMGCet+vnSnYiRp
         dMEsasTW/RZl4tAgizD4OiGBMb117Phz6sf8kk2+l9oLA/guWjs+pEdhTVa2HcVFuqSp
         QQ2+e4xQZCMl+GYuWc5Ei3jV1o21TIyjm3UDtXrWfHAqT6QgLrCN1TPdCKKu5ewZb4gj
         kWNA==
X-Gm-Message-State: AOJu0YzawURk9OF4q4O6MpoXY5aMwB+UPby16DwNPPjfLCHZUZ7rgiuX
	W/WhD+zx38CpU4UmGog1rotxgOaFinV2v9ZINwaUKRDG0fKU6Z9vn4aNC9vk
X-Gm-Gg: ASbGncssX4dWxNuIGD+ClLY4eAtNmylN6zN7GFmf2Tc/2eG1cT+nxb6qUNz+bjampVF
	82WK7mYlcHWr3uEzkC75k4qXIwo0p8brMzrJ9IGapE+R1XgpmEVIfC2mESWlQAwm/YxcT887Wak
	9PpIzrbVCB3hYDE8moMHxpe+sWlNHFKzZBrJzND6SLaTyKfkqG0K6iQqQDFoBF7K3E4lU5OTd0D
	uxFCrcVIQHj8y8WyyIGyQNw5xFromsnv0vaHBYIUgYqvHfawQwpebpDPMB97oTODi44zwz3Uc0G
	7340VN2HoXf/B++8UwCftCPDw5DyZ30t/LYL8iko4rgLBeOobNO/rB4ShzdymUdEgdG7FZKD
X-Google-Smtp-Source: AGHT+IHeI92UQRjT6gzXUs0UIgOH6j562/OURlMWEam0UEYzZICS/xC0ALdrii7iVlYX8JZnzWxb2A==
X-Received: by 2002:a05:6808:2dc4:b0:3f3:ad65:e419 with SMTP id 5614622812f47-3f3cd71d0a1mr4739893b6e.28.1739450448416;
        Thu, 13 Feb 2025 04:40:48 -0800 (PST)
Received: from smtpclient.apple (syn-024-171-058-032.res.spectrum.com. [24.171.58.32])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f3daa19849sm418402b6e.44.2025.02.13.04.40.46
        for <live-patching@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2025 04:40:47 -0800 (PST)
From: Matt Cassell <mcassell411@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Unsubscribe
Message-Id: <3D2345DC-93C0-4F6A-B7DA-8FBF2F347A8F@gmail.com>
Date: Thu, 13 Feb 2025 06:40:34 -0600
To: live-patching@vger.kernel.org
X-Mailer: Apple Mail (2.3826.400.131.1.6)

unsubscribe

