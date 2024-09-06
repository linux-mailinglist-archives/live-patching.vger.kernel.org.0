Return-Path: <live-patching+bounces-614-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC3996EB02
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 08:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E88E71C20C32
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 06:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D797143871;
	Fri,  6 Sep 2024 06:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NpDbag+T"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F1714264A
	for <live-patching@vger.kernel.org>; Fri,  6 Sep 2024 06:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725605495; cv=none; b=pmHp5IuKtFuGp8bCAlPUYzFeB5WSHl82MZPVwQ8SHla9iJVrVtJpcuyfHzljbBqImj2aq4pxTD+M9SpL2CMJYFBmMgHHh2zTrhpkzkYgxO+OuGkOrflAhF3gKEwCITqQDrU4qe7tbWncgVQLQtU+Hh72enmUdgznE4z7vKK/+lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725605495; c=relaxed/simple;
	bh=SLxU/KchM9lZc2iifzYGl0ikYTYXfIHuX2seBA/+tVc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fJCzKZWCjXgtiYSx0+tQSpTqwnoh3xW7Z0E9fopttBibYCxrUkxeX17Dx04Jhxg3n4Bqp9RmWDxPN3aPHTzAGdpuY3LIz9k4dpS175w6WHI9UP3vve3KS1YoijHVJVlrB5BTcWdK5nAX+T7WBbG8RbahpJKuD/kCbDvQ85e8Hwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NpDbag+T; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2039ce56280so23534675ad.3
        for <live-patching@vger.kernel.org>; Thu, 05 Sep 2024 23:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725605494; x=1726210294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zxPgcan/wlGxIATORmsnmNF0mblZEeZI51ZTLUgDKYk=;
        b=NpDbag+TArpq1AhPCdiUFtwQWEGzVtDHR8tE+LVKBbjY7cb1krGqK2svuXU2z7QuKj
         wZ7WxsMmQadyurdT5bDBy0y6hhAt0ZIrXQ5hLsLAXq5YhXv2/vKJ/Ea8jHALHxPUNNa6
         YtsfL1eaBSo6b1mbDhvB54TUi2zVlXsgIIZt94Xrjw0s36cJwjTcji1ob36fatyu0kti
         6kZwdySaa40Sg+80yBVMK36egrTh+SYJngQvNDha7YfXxngMtuNl325cETABeDtvfOLv
         mnedCer2wR9JKzTbMqjSmB9eaoBzuqh2ZX4nZmsJ6tRs8p/2biWca8f4Iac9KApfxYxS
         xbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725605494; x=1726210294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zxPgcan/wlGxIATORmsnmNF0mblZEeZI51ZTLUgDKYk=;
        b=IHm6wQ1YUxZfHM4T0xbugJFMhqDq7B8o4uME6FO+eI5qMY3StWJwo253JgjJ8JT020
         Ob8X1Bbr1NNcmEWivJ5pTuckf7oWGdHmFxV2VF5ol4T4Y8fu//4rjcez3JovpUSNS4tn
         tcwt+FOsd1Fgm5/Y7boPWeSYyKN9JD8IKk8ZTckNcq4WjuB8qxXHcfKbpbb8VQvUmKx8
         f2MTvVqHnJKgbPMS716/n48Jzi0Ji+p3XrAoA+m/HPUu8t17JZ3zXRpiBiPt+9FJThis
         MHcKHirgkjapCgJ6NKLfOorGaFbW32QHyMtvjGIMLg4vN5c+aNStkchE2GDDQmjyTL83
         pKPA==
X-Forwarded-Encrypted: i=1; AJvYcCUZylWcM1v4H5akPt4vR3g9Gxh0F8ALziCMZYHCboDb77znYsPQTDkzDYMUUQulpcaL3LfWn8JU5nw48LYU@vger.kernel.org
X-Gm-Message-State: AOJu0YzNWtyO6gwDGPTeZAVie+8OO7fRKvTS+pU0f0lWblsQsHWhaywY
	fupzcbWeIiytodnjcy/2cuawUn2uzRz96cDmvOS5VXw4G5ZXgWSyuFMZ7guzKl3oJ5FNnZcLAg=
	=
X-Google-Smtp-Source: AGHT+IGmwK9ZlhpLJHzZyb89hyaIZmCCVBcaqPhtMO6n7z0xo7Bo5WKyL7fOirbZ9TqadWXU/2jE6TZH4A==
X-Received: from wnliu.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:270f])
 (user=wnliu job=sendgmr) by 2002:a17:903:41cf:b0:205:6a9b:7e3c with SMTP id
 d9443c01a7336-206f0357b15mr663405ad.0.1725605493719; Thu, 05 Sep 2024
 23:51:33 -0700 (PDT)
Date: Fri,  6 Sep 2024 06:51:32 +0000
In-Reply-To: <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906065132.35917-1-wnliu@google.com>
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section entrie
From: Weinan Liu <wnliu@google.com>
To: jpoimboe@kernel.org
Cc: jikos@kernel.org, joe.lawrence@redhat.com, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, mbenes@suse.cz, mpdesouza@suse.com, 
	peterz@infradead.org, pmladek@suse.com, song@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

I'm observing multiple compilation errors when using clang-16 after applying this particular patch.

# CC      init/main.o
<instantiation>:4:1: error: symbol '__bug_table_0' is already defined
__bug_table_0:
^
<instantiation>:4:1: error: symbol '__bug_table_0' is already defined
__bug_table_0:
^
<instantiation>:4:1: error: symbol '__jump_table_0' is already defined
__jump_table_0:
^
<instantiation>:4:1: error: symbol '__bug_table_0' is already defined
__bug_table_0:
^
<instantiation>:4:1: error: symbol '__bug_table_0' is already defined
__bug_table_0:
^
<instantiation>:4:1: error: symbol '__jump_table_0' is already defined
__jump_table_0:
^
<instantiation>:4:1: error: symbol '__jump_table_0' is already defined
__jump_table_0:
^
7 errors generated.

--
Weinan

