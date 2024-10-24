Return-Path: <live-patching+bounces-758-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2489ADED4
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 10:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 386871F23890
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 08:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F39C1B6D1A;
	Thu, 24 Oct 2024 08:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YWj12nDs"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1DF1B6CFC
	for <live-patching@vger.kernel.org>; Thu, 24 Oct 2024 08:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729757715; cv=none; b=JLZkpAYuypevMk2W2/IsA3EnUBAxZO8n8N0xo1uV4hpqzhUOTHm8orrW6lgB/UXN0jfgejG5Om087dDim9/HChxYwd7RxOoGagviZwaXv4c29+tJ2SM1Gp78Wx6uiKQjJfQnYU6qtmLWmLP8B6CmTF9YVGB+z/JvrjPqBN+7Qss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729757715; c=relaxed/simple;
	bh=dXv7lh+BLcIRzudrbKwHjxbh1cdtzCTfOp7Kz2tK8h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rK0F8462OM0bs2zEQVJiiq28j5BPqZ8cmV5Y03E7cDyl8gTnUXLHgPxHW1uzKBlQxvbZVxNda1pRUIcioV7SuiVNDItp89aLnzuJrYb7FvRXWnK8AacwBq/oCZOjjItiYHVPP5/DAWEFyp9psVATFDGyCTFm4D+vuCRHCm22n7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YWj12nDs; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4315df7b43fso6721905e9.0
        for <live-patching@vger.kernel.org>; Thu, 24 Oct 2024 01:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1729757707; x=1730362507; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jdHwvluF9d5mpTyj2QvbUGMMKLF4PrNsenGLNKqAMOo=;
        b=YWj12nDshmaoxJBuBPODCTba/ZR/mBjz3pFMW6XOEf9bHKqSCCN+wFAi0yLdzwWB7X
         CVlFxFKL02LXovsCuiWmLG68srrjtiPWVYvyJV3ml/v8+7EKESlz0QltORBt7XpNjqep
         +8z/hzeCsqFfs6rgj8OJKJso7JrdBuRf2THKVCiTVkdwTqAqbOSOwCYmg1I5M01MScie
         HzymM31BxrD7V4w/LXfKKi3ugzY9J3lUDgk2eE5nQUp37yGggtBEJbxvQiE2Pkq9u8vD
         0bSVKOs9smGnI1hQfrubkfHhFlUCOpLC8uEOTRo+IGJ0P+4cS95ygATzd0XrhF1h9Y9+
         YZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729757707; x=1730362507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdHwvluF9d5mpTyj2QvbUGMMKLF4PrNsenGLNKqAMOo=;
        b=qofKaOnAL3djepQj6l6+CMU1DLWOhB+uhjMYJ4VE3zXOmaL2Dyfp1XNbQCVxZx2ysF
         G6LvYK3QmoNUp4xspCWhvBI3zduitGbiwPVx0nxFPprahllia24v+dIa8SKTgHSyiuzC
         1OQCdYJrxAFB8avnmEWjg246b67PXJJBXQFoqdDPIoUvpWpG/ZCzAxEwoDdS8o7walrO
         jY36hNghtGcX4gmUKwaRQ0dwtom3fnEXFh6oJpATOkR6tL/hwYMSIMXlS/p/J8Nzy4T8
         sjVHptC2r4YbHj7QAZQ9tEEnlrDoVvu15j1hJ92hGwKmAcY/+O7ILlhvW3XqkG4pyOV4
         N0Ng==
X-Forwarded-Encrypted: i=1; AJvYcCVzBitcKu0hag4P2k+vhMOF4Y8xlh50QmP8g0uHrbpvrivzcBeh0HPvlFlj+5OiX585maA6p/S5cqlECi+5@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcj2MFxdkIlWk4riRvDcH6EFzbJLxwT9xPyMaYo8eXdmbgR7Ls
	NpCyXwSXtBlwnmDxmNR25wYK9p8s3w+KXM9WrmDa2kYFm3gLdij4yWZStGGw5uA=
X-Google-Smtp-Source: AGHT+IEXI5QgJVMoGUbzlfwpuFVn8bN9pJLOzzVjOGLLhtsS2RoOTGIAujFl+DVo4gw8s3lu3Fx8lA==
X-Received: by 2002:a5d:4444:0:b0:37c:cdb6:6a9e with SMTP id ffacd0b85a97d-3803ac837dcmr905560f8f.9.1729757707223;
        Thu, 24 Oct 2024 01:15:07 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b5682c3sm9915155e9.29.2024.10.24.01.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 01:15:06 -0700 (PDT)
Date: Thu, 24 Oct 2024 10:15:05 +0200
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/1] livepatch: Add stack_order sysfs attribute
Message-ID: <ZxoCCasDtqeXdSNP@pathway.suse.cz>
References: <20241024044317.46666-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024044317.46666-1-zhangwarden@gmail.com>

On Thu 2024-10-24 12:43:16, Wardenjohn wrote:
> Add "stack_order" sysfs attribute which holds the order in which a live
> patch module was loaded into the system. A user can then determine an
> active live patched version of a function.
> 
> cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
> 
> means that livepatch_1 is the first live patch applied
> 
> cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
> 
> means that livepatch_module is the Nth live patch applied
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

This patch is the same as the one at
https://lore.kernel.org/r/20241008014856.3729-2-zhangwarden@gmail.com

So that we could add the already existing approvals:

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>

Best Regards,
Petr

