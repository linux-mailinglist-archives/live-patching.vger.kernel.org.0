Return-Path: <live-patching+bounces-710-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F40198F1EB
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 16:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23A271C20EC8
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 14:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 958DD19ADA6;
	Thu,  3 Oct 2024 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+eE4+IV"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5AA197A65;
	Thu,  3 Oct 2024 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727967286; cv=none; b=JzRWIBOjSg4oSSz45yueuuwYi5LjRtBTbys/HDmvDHaqYBukxBUP7gay/H8bh1TP5/WeGWHNrly8bKnd5a5lkVCY9qvL8gPNn8XJQIf3F2KT8EeIHv/yMXrA2YjKqrlPOUGNoJmr5vJ8by/txbTTNXNidXFbV5dK3Y8t2dB6VE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727967286; c=relaxed/simple;
	bh=uZT04iLPoVH61EzFHUulkVfWq07rul/sIu7DgbW9cGM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BpO7az0o+i5bzuo5P95YdUaMzx8+nZNjuwELPybTFdienr4Bcd5KYtcNy3z3GVG3T76wsEPx2p89obLekXbN9zrNXc9GTxjQnVcXdBgUiGxrkBstkiQebs4ToXQZXiWyqNinMeVBlJcqoZCK25qMIqA2XihqKHSxoVVtimhx0z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+eE4+IV; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20b90984971so11210615ad.3;
        Thu, 03 Oct 2024 07:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727967284; x=1728572084; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cg9f8AAouFbGggtUAeWVFr1axZNtUOVGqld4t64139o=;
        b=K+eE4+IV0x3j2JnWuiVv3YWFzzVsSthE3gxjiuPWnieZXTC79OCu8OURoL+NGvY8N4
         4tA9lJILe7JI9OWpGtaD43D/WI1NdXiClF1vLKNit+GytpthYOCO+p5bzicWDlTrm2R1
         Mxxryffhg3NDnCpqq/VIGPLnhuEKw7ZDceJMU5Aq/ZIYbJR5QN77EeuWyEw8yNh1uR2u
         Jsmp6jjZ+7jEvSJfzxfxVCn0sFtWvx3dKwSmLyHm6+18i+eejszdf9i7FdNwk/C+ZqXo
         ppfD7fLjcGNNW8B2RPCaXhRI1ZAEDejVmedwUgO65wf4lA5PjqmdLW05gkVQTloO8xku
         YrLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727967284; x=1728572084;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cg9f8AAouFbGggtUAeWVFr1axZNtUOVGqld4t64139o=;
        b=bjL9cMhoAelmYUw0J5oXHIFWtOkZZxaHEzRRKw6xVN8fhzju/5R642PQgpsboG6g33
         gn/3rnU1hi44BaaSzqvsyGmDcFYlybvzFU8+jmQXEdagWESH4F8s6uX7BmF/OhF1PkNk
         dqLHr4U87Fg0wrR9JH5KuLPJ2OCeabKcov3JSI6sQrf6FJCJ7c4xkdsrihvJdIFHZ4qd
         RSTbu3fDq9DRBWeC3WK8VOS7CelLMFkrVWgt0MLFHBi3FNlXYNJkY3CP3EF917sylgkW
         jnEvLNuD8B6CkSpO478+nNp+a7PhoitnfWo4OmSD/HZpOjTQ7bxaQiS3wQWhbhSewuOE
         tong==
X-Forwarded-Encrypted: i=1; AJvYcCU6/1CRoJFb+5JTvh9TJNZ7o+e25WlW6mB8aQDvMWVdm+BzX8ZLm/3vGp7r9D4XOzT39pMMIplrlYXFHyU=@vger.kernel.org, AJvYcCXWOGPpPICc2lawEqNd8vPt9IPuwnrnzG7Lh79+iQZFd1Tq8ZRU5dSKzfkOS1K8vj0EVMnu6PWH2OZeRCsdUA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/Z2UUzSuf3esPvl54P5+azLqE0+fBrKzuSGYOc9UYNKANWdCQ
	0667oSRGMDIuEu5Bb8xnV6ygMtXAM+UAILtIH0i8W2mvhDZprxFJ
X-Google-Smtp-Source: AGHT+IG0BFSna3W4LN8wo1ab8T3hD+OjdQlWZUfyqNt9EsvJCBriV3EkgCXuAT4lco6B4hbUUAXT4w==
X-Received: by 2002:a17:902:fac5:b0:20b:54cc:b34e with SMTP id d9443c01a7336-20bc5ae9657mr81941555ad.51.1727967284421;
        Thu, 03 Oct 2024 07:54:44 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beef8ded5sm9900375ad.174.2024.10.03.07.54.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2024 07:54:43 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH V3 0/1] livepatch: Add "stack_order" sysfs attribute
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <alpine.LSU.2.21.2410021343570.19326@pobox.suse.cz>
Date: Thu, 3 Oct 2024 16:09:23 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <FD1037B2-3CF6-4518-92E9-F079A7598B0A@gmail.com>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2410021343570.19326@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Hi, Miroslav.

> On Oct 2, 2024, at 19:44, Miroslav Benes <mbenes@suse.cz> wrote:
> 
> Hello,
> 
> could you also include the selftests as discussed before, please?
> 
> Miroslav

Should I include selftests in one patch?

Regards.
Wardenjohn.



