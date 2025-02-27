Return-Path: <live-patching+bounces-1240-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85EB6A48221
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 15:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0254166366
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 14:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D811E2405E4;
	Thu, 27 Feb 2025 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gZBeukRG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B389B23F40D
	for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740667562; cv=none; b=MCGB7NAQgzHz23FUI6ppxs6vY/FgbxqL1J/fL230VSKKy+HkB15uozdt33fFLqVgwuzepu2RBMRsrGNxbv+Y93qqCt+7vNv2rybDptgjDm/OzZwbATUYyLpr/C47QUA9Bcemzmio08M3UpBA1FSSmhg05pM7yXO+gsbSjrYhDlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740667562; c=relaxed/simple;
	bh=gMYpBsRG2fjjwsifzXe4adTmEFIoYkvbFhPPf587OYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/pdUjXg8MVQ4Ydjy0iW2SFCnU+s5D4D9zIWBLc9I1iGGCI5wEYKv5EN0p9Yy7oSloimOvx60S6inANnEwthoQ7Jo+NnX+Mx204N43tCqBuGGPvdkM6+zJMIca9s8Phv7TNx0mkht/BIgu6U2AdCGv76Vdx4GcfC5SeZTOnwIdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gZBeukRG; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-390dd362848so817684f8f.3
        for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 06:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740667559; x=1741272359; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vtL7q3Ul/DLwjv7Mftajy7HcwntuRlRBkeRAGnJ1Hgo=;
        b=gZBeukRGVFJRNfX9mXJPnj0y+ak5zGMp+bKg+M0QH6XGMcI0oUqF4AbVj1Ue7dZtPy
         iyX4Znlw5rI0ZC3TdSKAA4NDRuzGynwQGoPfDvDw3B6BtKizh5H/xrXD8y/5ABo451sx
         GSWFeke0ZgbjfrhYRjfxAJNRKuxNLblHOpJSnaLx2pi0pLjeDN7eO4UpRiljiQDV5gsj
         XGoeVMQSVfyOzRFajBruIZJgDV8Sff4DQC+CV1AQBxzIl60k056YvzNM4TKrWZ2y6yLf
         CwfmnEwQUm0iny1uVSoyTIROskUKq8GxNjqlUG4x0QJn/9wos+anxTMksn9sVllCOf3C
         P/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740667559; x=1741272359;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vtL7q3Ul/DLwjv7Mftajy7HcwntuRlRBkeRAGnJ1Hgo=;
        b=uvpUb/sx7WwU8kApk1ggNJhUy8C6tgLrksQA5WZ2QjlzCqUphuq4NbMFEja+bqx0Nv
         NOap3zS0NKKEW40CoG/6Zys795F1eWm39ChAnGEAcelshioPxuVFUfLfR4eCuhp2sLR2
         e9Fq5kbjfMPEdiOxIL5r0xuVaFlJ0+ttuPX3sJto7YPNeGJID1aZJRXv4TWnlDP6TUYY
         GIur0ZL3myjZRT1PILehZmq7n1nYfsq3rYmOKtJgBWD62UW5rJiW87eF0hXG2D7VbKDH
         3YqU7g3ucECihhfnsuZvo3m+n6nblUHUcEJlDi0kDK0/RJ3JCSZRfUipI3kckoRy1jre
         RY+g==
X-Forwarded-Encrypted: i=1; AJvYcCW9PFD0a37cPCBFWZqzJUh+1rhGHM1QL6LKTTKFAiRmBctXsW+VxYnt/Ghx2yfPauG35oBbfQefVNf4IqTe@vger.kernel.org
X-Gm-Message-State: AOJu0YzjxceoRjQR1tLG1wPSbhxk1c4rNJh8D8vyUgaU1X28+pnjUYty
	bIb8NqR+AmPrEf9hulguM2LoDU0Ji/VVSvW84GpHAGZKUghbMtjs/CuQzviEyw0=
X-Gm-Gg: ASbGncu/OreaSmPnHsIPCg+sxf9U2HVrvOYrm6kqvjQ4w+oyYCvZqNlWp0kGmO3O9NH
	Y43RDfswD2QJ4DJF6mPpvWuwdXnNRMw88F2JI1QU7IfDAK92966kcxQi9zVh1IY9LzwelS+Hdcc
	WkMs4BgMGgY3ETAVsoRzMqbNwIQJwMWYEwsH67Ic1iAmyokNHrOZepCiPHPDi2lMa+LOqxr+JEl
	NbujEf4kXfBxJAzXaenmBBByHXbRErNWF6cujqGsFqc15ennaM4KjGkVXKxluBQg4z86QAbZ2AJ
	Wg015WdILKzCFMqk5WNB098I370C
X-Google-Smtp-Source: AGHT+IH2KRRLb5uaUom0nQINUTFlw07y4ZVNORpwaG5NyYReGCB3T/mqrGbx+HDOt4+U70OnxZHU5A==
X-Received: by 2002:a5d:584b:0:b0:390:e94c:4514 with SMTP id ffacd0b85a97d-390e94c4877mr961319f8f.17.1740667558989;
        Thu, 27 Feb 2025 06:45:58 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba571274sm57490645e9.31.2025.02.27.06.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 06:45:58 -0800 (PST)
Date: Thu, 27 Feb 2025 15:45:57 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v3 1/2] livepatch: Add comment to clarify klp_add_nops()
Message-ID: <Z8B6pXGtqSYxADg1@pathway.suse.cz>
References: <20250227024733.16989-1-laoar.shao@gmail.com>
 <20250227024733.16989-2-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227024733.16989-2-laoar.shao@gmail.com>

On Thu 2025-02-27 10:47:32, Yafang Shao wrote:
> Add detailed comments to clarify the purpose of klp_add_nops() function.
> These comments are based on Petr's explanation[0].
> 
> Link: https://lore.kernel.org/all/Z6XUA7D0eU_YDMVp@pathway.suse.cz/ [0]
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

