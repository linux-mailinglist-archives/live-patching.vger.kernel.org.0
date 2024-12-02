Return-Path: <live-patching+bounces-873-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A54F9E00FF
	for <lists+live-patching@lfdr.de>; Mon,  2 Dec 2024 12:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96479B26CA7
	for <lists+live-patching@lfdr.de>; Mon,  2 Dec 2024 11:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EE21FECBB;
	Mon,  2 Dec 2024 11:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f0x2lwrB"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4729B1FC7EE
	for <live-patching@vger.kernel.org>; Mon,  2 Dec 2024 11:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733138663; cv=none; b=PaRD0h5iBYu//GJ9P0JTx1lOBwDpQa3ensb6P4ep3+a8GkMkPwkE4Lb8rnYz9/bO8YysX4T+PZCYizk5KU7OXvomlq4BM4EH//tXN5SeTxiJMxi2Tx/iGnkzsH3Ys2LW7yovSY7JMSiMwxYlF9Mdz8NFLP5e77YC7rsNc3y6H0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733138663; c=relaxed/simple;
	bh=Le/CT0HdxkOxTxpEIgbZs00IaWmCTN8Q+VVslanzm5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJ/CIyuEgnEL4E7Mc40LUXBYNHEey/hFDDCTSYvoZ4W3mNZ8hcKKvhwt4TkvzjZNYcYpO5OV+Rz0JKhF4InJjfb3qkn4BaGY7t7D8vG4iQGJp6Yksm8sZbosTi3Gx8K6s5uSbtvWwV9G/5FHByAFgFHkoZVjfCfbvc8cU4ATEgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f0x2lwrB; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d0d4a2da4dso2129114a12.1
        for <live-patching@vger.kernel.org>; Mon, 02 Dec 2024 03:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733138660; x=1733743460; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=obnJSmZ+xwHfGrcrn3ssi8SdfUDTV1zzk++2UAhZeVw=;
        b=f0x2lwrBlohWdT0IgSS0cuTk4a42jUDqAMW8nQ4F+GGvYOFy2tSfY8wggTgf13y/72
         Pwe3qE3ntwgWq3BJ2F7bvKit4iMwXPpmlXJvVgeS5Es59aW6pWKZDn5l+dQn35NG2RQD
         hfUdvPw1ULrXachWTAQIouelQtnEghKg+ZTJ6t8HQkE2cT6fZLNXl4tmbffdFN9SFopf
         QVzS/BV7yEl+ixVLlpKLrheK1hu/unISYjTwz6nusXgqTB06vHl0nNqieGHHY6rXIYZi
         4GeKW5amgn9nLhsz+x//e/3sm0kUP59EJAZcB+r3sb2Trz2A4fgT6yLQ13rUYIwy5VC5
         Zx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733138660; x=1733743460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obnJSmZ+xwHfGrcrn3ssi8SdfUDTV1zzk++2UAhZeVw=;
        b=AhTkAUP36S86ndFdyqRv4FryT5+FypOPa8P3bUDb7JRpK1ybjkAP4HU1zBw6IHf6BE
         7piY4gVPmifYNIqeli3+UjjVxj3jCuTF/0ruKO2EDQ9Z6XJ3tu+1XUOjOSzd1P0N8riu
         g6gYlWWsv9UQ4ueucZbb58nYCbWQWOLWuYv0Wfl3TF0aayd1QPDvDTk5NsusTonTAxSv
         sqUYxcmV+f3DoRi02nnX3flaR7CjHUu5kIdBiJrjJC6VcdST6gcbmzjlOTVJN/O23ZxK
         6EqAbVozLu1OqEEDX9afzwhMAo+IXl3CEKWk2aSZr6FDFwjoMjA2IRCTSU+OVkMlWtwj
         TyxA==
X-Forwarded-Encrypted: i=1; AJvYcCWSXzhA2zx7VtMd9DIrhvH3e5SQuxJhowhWhJsNtnf/yuVTHmhX5oq6egq+UFZW/YblCYwfrdA4lxfcMZRH@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8GZUEN62HLU+A4qvShzxYcyCbgaZjhhO6xitFZWAf0YKFTRkT
	Pmqqpvz96KaLS9J6CG5NSq50dD7KFeKb6/y0orknazaR9+VQmSJweXpDdyjjSU4=
X-Gm-Gg: ASbGnctBtV6SP6g+U1WAwhUAcllOL94irO7czaEWa2tlNti8WUfPLGlWHUlCYMQdpmy
	7bUbOlElAQGZXACKCYHthGq2N4mXpB0Xm5mUt7vJ14xK8R9rscHOw3uUUSG9cnuGT0boomr/8th
	GI0RG72Gys92iLdndfx/Y34FcFweXyNKCYyIhrlE8FnOdn0/PIrXuy4IyTY1WKqBr/+X9WbcdeI
	QiX5kMcW+4lma7VawInbK/fPIu3sjyEjG5pxR+HD3YVZira+SI=
X-Google-Smtp-Source: AGHT+IGRr2sfa3kPmLX9QQIs8OutMaXCzA3Y9HC3xsDdeYaVS+Qq/jH3EPQXM8M0WSw/SJjyL5wbUQ==
X-Received: by 2002:a05:6402:13cb:b0:5d0:e871:f2ea with SMTP id 4fb4d7f45d1cf-5d0e871f402mr4705115a12.16.1733138659730;
        Mon, 02 Dec 2024 03:24:19 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d0e27b3da8sm1761821a12.5.2024.12.02.03.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 03:24:19 -0800 (PST)
Date: Mon, 2 Dec 2024 12:24:16 +0100
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] selftests: livepatch: add test cases of stack_order
 sysfs interface
Message-ID: <Z02Y4C5a-P0kbaq3@pathway.suse.cz>
References: <20241024083530.58775-1-zhangwarden@gmail.com>
 <CD7BF255-7128-412C-86EB-305CEC7FF2B7@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CD7BF255-7128-412C-86EB-305CEC7FF2B7@gmail.com>

On Thu 2024-11-21 09:36:25, zhang warden wrote:
> 
> 
> > On Oct 24, 2024, at 16:35, Wardenjohn <zhangwarden@gmail.com> wrote:
> > 
> > Add selftest test cases to sysfs attribute 'stack_order'.
> > 
> > Suggested-by: Petr Mladek <pmladek@suse.com>
> > Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> 
> Hi, Petr.
> 
> Here to remind you not to forget this attribute for linux-6.13.

I am sorry but I have somehow missed this patch and it is too late
for 6.13 now.

Anyway, the feature seems to be ready now. I am going to queue it
for 6.14. I'll just wait few more days for potential feedback.

Best Regards,
Petr

