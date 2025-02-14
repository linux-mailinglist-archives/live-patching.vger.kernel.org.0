Return-Path: <live-patching+bounces-1196-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32592A35AB0
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 10:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8C811891EA0
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 09:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E47242925;
	Fri, 14 Feb 2025 09:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F0dn6XyR"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C329D2222B4
	for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 09:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526389; cv=none; b=S6ZJey4i28SSDxnJYuzV2IOaGCP+0318DG3Wvw6R3Yd5tUPUEti1GFuRey8bxnxE3ZBG/z1Ega43nbsRYc6jtPDQQcvKhW9C1ShCPyjUHga3jxnKWVj3G1hwD+ihydipOnTFRRoiOawh76Wqf9NpQ5yttwmFEMUtHYamIlEXock=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526389; c=relaxed/simple;
	bh=vOfy5kvWpR1B9gTtTIoxk9JG/O5o9GEiyj9Sl8ce3pY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRu5rahU2nwuSbY208I0mfQBs4rIwu20LS1HUxZozlPkYR8JxdKpFuOQSCbtLbCc32LHZsoageWUG9teePU4x0bsy8Qc1rGcIFIJ9p9F5GwRL2T+F9AcsqblbfgQko1TEcMeG3MsvhqfZ0G+rGwlsa6EWuN9H71M5wdcfb4mPsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F0dn6XyR; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5de56ff9851so3306843a12.2
        for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 01:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739526385; x=1740131185; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3yRIEVca12C0QJydPEftedSD7qv5N2a4rqHkMNRz1Ys=;
        b=F0dn6XyRtnFih+Rtl0VXkNe8+xLwG5EE7d32c5rg99bnBNeNTxC0UrZeUHP1xd13V2
         NTg/tJVL+hpyLfLVVVZ+XLN3dF6LdTcu+P/grM+J3dlTbcyS+3wM8wdLgvwj9mENqWca
         8K/Gc7Wv7oRZVjqqsc3bPiJ1qyVc5K0WwzFnaZZ8prOd5tUY4bnL7cMJ6R454p9xg1a9
         Cab2sEXjIrzRaY3csqFyEVd/cWLHlkqjvbMJUqOwkdkNyYtEc9LENbwsbHt+bkEmLttE
         bWoTcDaqwPXKAgajV3aCXWO8pz/6oIciCYcrEcfz1LjNll9k2WvOc9rCGb6L0ALTiSkB
         KUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739526385; x=1740131185;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3yRIEVca12C0QJydPEftedSD7qv5N2a4rqHkMNRz1Ys=;
        b=XdVOqp85qGr/tsLxw3ZF6TA/v2mUcDzMYruGSuTOzLnlHLUEkSN2fg7miuU84Lzr/k
         9hq3v3mR7baPsz9Gv0M5louKjQc+aW97l8e6v1s1EWf9r4s7jkBuAZpC6VXo276dUB7m
         cPGBgNS1G2ZGz081lq7GMcB260RKrfTiqf0qEZRqfLodr0oioi2wQUK5Os1+BkvL0SQx
         bifbbTbpxeUI7ZZ1RLajt9i2obeKncXoZ12MM3ig6RhjYeYMIefu8SqjipzTZQp/DGmJ
         soFUjnnhfyVOcM99IrSEIO9llUFKNQZK1e0/GTJ4ZMiLNuLu6DKIOhi8LIfcUCSI+Rsh
         gi5w==
X-Forwarded-Encrypted: i=1; AJvYcCXRQx/FJZeH/caV5Ivht0WkplVdHITGq+E0zCLcF4n9G8YZydBivGZIxGW3G5CBoW/TRi6NjcWWw8TknRtu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9yZFxVPeDs8c8DRIkRESr7GhdLiItlRjPHi48a54xWDdNKvRF
	owiueWC0ZDxcdnGisMqS2hDjjtQdmwVyiMPWom3rDBBlicOjWP0idT4Jtl7nPhQuf2xE3IXSra8
	4
X-Gm-Gg: ASbGncs3CBHYG5h4WiRGUMmxDg+8A8kt+03jHuWlyySZE7fqpNolxnSfvNJuw2MXWUi
	yS5i5qBU8Tdztu2jfevbrrDFDkzNvOcWmUIWvkmm9bUEdEiey6tc+saNAb6W/lcfUhu+nkhWXpN
	scklENqG9yR/oB3R/ZE3BICVYMypizAnvxAH5aUk9GO9biTKP92UfEsLEBv0xVlBY/IgHd5LgCo
	ok9RuTdx37EKO4GLbEGZNlvhmM9zsAOJqgtEtkkyvRS1gz9ZjhrYE9gvHI8RF3lpqT5Ml0tf2xQ
	W/M/nQE3xfX3AX2XVA==
X-Google-Smtp-Source: AGHT+IHcx5l+J79iCkY53YQ7rGr5El3n+GdVx39jXbumJ8Sx0e9b8nWgzg18TCKQ/de27/2kpAgvEw==
X-Received: by 2002:a17:907:728f:b0:ab7:b072:8481 with SMTP id a640c23a62f3a-ab7f38745b8mr1097916866b.45.1739526385018;
        Fri, 14 Feb 2025 01:46:25 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba53258215sm307599966b.53.2025.02.14.01.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 01:46:24 -0800 (PST)
Date: Fri, 14 Feb 2025 10:46:23 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: Find root of the stall: was: Re: [PATCH 2/3] livepatch: Avoid
 blocking tasklist_lock too long
Message-ID: <Z68Q2j3yCB8N0n1n@pathway.suse.cz>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <Z63VUsiaPsEjS9SR@pathway.suse.cz>
 <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>

On Thu 2025-02-13 20:32:19, Yafang Shao wrote:
> On Thu, Feb 13, 2025 at 7:19 PM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Tue 2025-02-11 14:24:36, Yafang Shao wrote:
> > > I encountered a hard lockup when attempting to reproduce the panic issue
> > > occurred on our production servers [0]. The hard lockup is as follows,
> > >
> > > [15852778.150191] livepatch: klp_try_switch_task: grpc_executor:421106 is sleeping on function do_exit
> > > [15852778.169471] livepatch: klp_try_switch_task: grpc_executor:421244 is sleeping on function do_exit
> > > [15852778.188746] livepatch: klp_try_switch_task: grpc_executor:421457 is sleeping on function do_exit
> > > [15852778.208021] livepatch: klp_try_switch_task: grpc_executor:422407 is sleeping on function do_exit
> > > [15852778.227292] livepatch: klp_try_switch_task: grpc_executor:423184 is sleeping on function do_exit
> > > [15852778.246576] livepatch: klp_try_switch_task: grpc_executor:423582 is sleeping on function do_exit
> > > [15852778.265863] livepatch: klp_try_switch_task: grpc_executor:423738 is sleeping on function do_exit
> > > [15852778.285149] livepatch: klp_try_switch_task: grpc_executor:423739 is sleeping on function do_exit
> > > [15852778.304446] livepatch: klp_try_switch_task: grpc_executor:423833 is sleeping on function do_exit
> > > [15852778.323738] livepatch: klp_try_switch_task: grpc_executor:423893 is sleeping on function do_exit
> > > [15852778.343017] livepatch: klp_try_switch_task: grpc_executor:423894 is sleeping on function do_exit
> > > [15852778.362292] livepatch: klp_try_switch_task: grpc_executor:423976 is sleeping on function do_exit
> > > [15852778.381565] livepatch: klp_try_switch_task: grpc_executor:423977 is sleeping on function do_exit
> > > [15852778.400847] livepatch: klp_try_switch_task: grpc_executor:424610 is sleeping on function do_exit
> >
> > This message does not exist in vanilla kernel. It looks like an extra
> > debug message. And many extra messages might create stalls on its own.
> 
> Right, the dynamic_debug is enabled:
> 
>   $ echo 'file kernel/* +p' > /sys/kernel/debug/dynamic_debug/control
> 
> >
> > AFAIK, your reproduced the problem even without these extra messages.
> 
> There are two issues during the KLP transition:
> 1. RCU warnings
> 2. hard lockup
> 
> RCU stalls can be easily reproduced without the extra messages.
> However, hard lockups cannot be reproduced unless dynamic debugging is
> enabled.

OK, I would ignore the hard lockup for now. I believe that it is
related to flushing the debug messages on the console. And a solution
for the RCU stall might likely solve this as well. Also the debug
messages are not enabled on production systems...

We should debug the RCU warning without these debug messages!

Best Regards,
Petr

