Return-Path: <live-patching+bounces-490-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E56951280
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2024 04:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 310A9B24D95
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2024 02:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 676691DA3D;
	Wed, 14 Aug 2024 02:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LnxgfAZx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC9A156CE;
	Wed, 14 Aug 2024 02:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723602777; cv=none; b=QZ5rXAEN+xGdkAS8qqkWrLgVn3zUT5OAZuWUboNdsZoNgQbFDemZdfLzyEWb4TEbWCaQEabb6escTtioiA5Etu93s8/cd1BVyABm7OMH5e1UVMWjpcLI0BWTML35xlUGg4dplQLD3x8cB0MLypulfUYcNQymrmVwMispiSRRmgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723602777; c=relaxed/simple;
	bh=hZ83TaiSEwcU4VtxR/2B1jmN+sS7vC15fsg8VgsPg28=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZJgijhDnC76ZV3d18zaq9x8ugInnVOkHAJUq9fw5XjhRm+4wf6JU9ksJdzOOqNAQ7B2GmJ7ej6UJ3AU0ucb7dB1HLi/XnkRAbJ3j+j34bQruLuE5SPbBKqnG1fEHv6woAxDiXKk9h+H0FnED2lrmwCDdTF1uO5Oz2AZalFwOqBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LnxgfAZx; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7aa7703cf08so4384063a12.2;
        Tue, 13 Aug 2024 19:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723602775; x=1724207575; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFcvqY0bUqVzcSU28j2w5cZ7NDHjjb9SV7GO+AwGItg=;
        b=LnxgfAZxjUcwlQbPE8zF90aL8IP7lDRBJZQTyp9JvzQip4obzxejirXQTuaA7K9LRC
         AUaJG700JUrC9PYg8ZAvVwVoXqDn886AYqpdhLJrEz7e8RwA6UoN8uNXatmT7IKYEqwU
         0uyTHha36DlPkalUNujRHTqAqElLLvngXyhWRiA/glnL+9k0gR4xedXjYUp4R86FFBCU
         xc1Km93h2IgZJQwSklxzBKhxCy8fgnQGnL+eZ1fHtEvhHjNmu1lIGJYo/8woBUsWezGG
         NWRTD2qFeV5u8p1DEly44mcw4OipAFDzhCzT1DJ9qBDzQk8o9JJhvXmliK2AjyOJAJJu
         aQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723602775; x=1724207575;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TFcvqY0bUqVzcSU28j2w5cZ7NDHjjb9SV7GO+AwGItg=;
        b=KwKEoq5z1Y13/r2hF8Fn4Op0cn/JSt+4KcdYC1KjUuzty+necOrF+fXzhXMRgfrawL
         4K5gYqoS29PLYzB6y9fq5NDu6GfLk4iKIuL72I4zGBJrrndm4R7BXkqnDAT6WTDT3jsf
         6ydnG3lcaBOywMs2lgh4MGK/1CYPDDj6fI1apr++bIT3Kc2OUWNe/+Hs6S0lP0oRpH9w
         xL3HBjlXvsP1Bx5RTRFzzSmmuzaZD0WOrbPduaZptCSEArJ/sZyFWmPiYiAD0nGvAuLW
         FPHXWUBKsKIvIFqc6rFUdUEGjDRvZIDXn5HFoy9YgLeUuh0dRJKNa9XaQ7nMHVMcnmLF
         6MXA==
X-Forwarded-Encrypted: i=1; AJvYcCXJUnbKH0tVKqXEgF1wBKDIiqu2mzuSd0mhnMH9RLJTUenSvHXLqjSbNPynZdF9qZsEEP8d0xZqNIExyVaEyUYym+DSnWk+16E0dSIExdXNZ1xzJLhxsn4N/uWYNudWfOI97z8zmytdk1FJdw==
X-Gm-Message-State: AOJu0YxoYvva4N1AxKOlTN7qf5U/rnkFeF1QWGNVyjb12GMy7Ko2FJtj
	l4oNu1CTOrSu8CZ6szYd0GgJOBqPtWq6ijLk2yWHprDta50QFEt7
X-Google-Smtp-Source: AGHT+IEYoH+VLjoY31qTt9OHRshT6X3F8NAmOaUaxWbGhEeRkx+sDmxGAn9HOnkOaB0EQAdZmfRS7w==
X-Received: by 2002:a05:6a20:c68e:b0:1c4:244c:ebc2 with SMTP id adf61e73a8af0-1c8eae97998mr2278414637.30.1723602775042;
        Tue, 13 Aug 2024 19:32:55 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1cfe86sm19991885ad.278.2024.08.13.19.32.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2024 19:32:54 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2 1/1] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZruEPvstxgBQwN1K@pathway.suse.cz>
Date: Wed, 14 Aug 2024 10:32:39 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <DBF78A85-D27D-4A77-9F37-9F5D69358E0D@gmail.com>
References: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
 <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
 <ZruEPvstxgBQwN1K@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


> The search would need more code. But it would be simple and
> straightforward. We do this many times all over the code.
> 
> IMHO, it would actually remove some complexity and be a win-win solution.
> 
> Best Regards,
> Petr

Hi Petr!

Thank you for taking the time to review my patch.

I will update this patch to next version with your suggestions!

Regards,
Wardenjohn.


