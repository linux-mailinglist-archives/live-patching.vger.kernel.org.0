Return-Path: <live-patching+bounces-1197-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A89EA35CAD
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 12:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CE961892452
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 11:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C2F263C7C;
	Fri, 14 Feb 2025 11:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XcUnyYH2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3680262D11
	for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 11:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739533039; cv=none; b=hCyEm81SACN/iuL3geyujIazT58K2Cj2dhvUA6+mfGgaY0h8o8exFy/8Gmop3DhP0UydVio3rVsJl4iNSh1ecTKIVPdbZiH3aRfl9ylEOi0/eforgbYcLgMRO6AoGERqsg+a27ulZ9QYfnN6X+BiYlMS9TbnszfXURzg6q+dA4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739533039; c=relaxed/simple;
	bh=QRuO1I8/cPbbmXLJq8QfXDR6PNbTSXSgQYPenj7sfZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRVTbhYNsbLWi38VD4Db6Iwh/XkHmmnRGvX85FTEQAmyMpohonJQ1FQsPeH+t9vemEds3jX3enyMJMIBT7xXeBWsfDXUraFY3Rgmlu5S8D25izNIX0XUfNK50tzYIg8Jxn5v1d3I0NoO7rVYQGZWWfkYsuGuSCzFrFEYu9qpIc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XcUnyYH2; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5ded1395213so2778806a12.2
        for <live-patching@vger.kernel.org>; Fri, 14 Feb 2025 03:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739533035; x=1740137835; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=acMkvdPbwbDy99R6pSYIkOvUKxnq+jcBTCUtRoirGb0=;
        b=XcUnyYH2QGEl0UX4q4M4+mZfQBB/6ki0Lo8uTNYPUukNZkpXQcS7voNtKGG52w1+fj
         E3mqqVZ5N8ByJb5w06mnsxNV+bAmvck9Yd6VtXzAhcXAOofzohSmqDk/rHYsqRudXIip
         dlOCj77zc2ryWky2xllWtUDnOsDePQrqUhYNDs6PTdq+2uTTQk9+WuunhLyEPHCCAGTp
         Op2/CktwCFS0a9vEvrWK1jm1XocCB2miE2BMAbQC5cFXs/phYQRqJ9w1I/p0/bVOOrLy
         5mtj5Es371WKyhUBANyPC5GoDxnLyy5cPMMQzT0hEbrvZAuW35Oe7DVnU7HuUjnaSv1E
         P5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739533035; x=1740137835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acMkvdPbwbDy99R6pSYIkOvUKxnq+jcBTCUtRoirGb0=;
        b=valAaPyLvnYQgwGECro/DaQWZiR/iNTmHCmLeEt8Uh72i0tOdedSyCleeYdMG6b+Me
         duuyiU1jcnkBwMF888DP/KVBtq9JPOLSqOWuaXbEU4Nto60+qdq7Gksj8Xzww9AqWMdg
         f9H2coHvlayrWYwF+EHy1fcUztN7yqcctC3y5gX0MQ2vBG6np+xY0srEKIpMtEf9Hnr/
         usxepctUR/cr9OSySVBfMEIcQW+8/84pSbvBZE0gBsxLmAyxs+NpJ6f+e+UANTNaOFyI
         7MNMZQ7F7RaBGs5+9ZV8ABg/MybCVYn5AKvfShKaQPMeX300xEKmz1rC7C0o+urJrfSv
         FZhw==
X-Forwarded-Encrypted: i=1; AJvYcCUi0ftOBmF3VlMzviCcxztth9nLxlqndATtN5Ljejw1xtkyknfran5LVaBkxGX+rmOeBfsdtZGVU/UO1zb7@vger.kernel.org
X-Gm-Message-State: AOJu0YzzwdnY22I/cCzNZKpJykkWfk/SyUttciOl2KtuT2V6xhdQeMkg
	92RuCH8chZy6tP3MRKeKehMDDK8jja8EVenhxb9j8Gkxno5neXGr+RaXkt4i80Y=
X-Gm-Gg: ASbGncuIiIWav4sUjsPpgqqxmUBdwLaWKeNtugMcN1L3zL3+gbBjvTgUvj8Eh10wRFi
	3omOUsvEG+/6n4xrbITEP5uEydOZwuyu/OpCF7Y7FQLGUZo6osWPItn8jyMVPxqsFVVL0diErEK
	Vka8SBSdoTPk4UubW7ytgrqjYD9ud+Q1lhY1fhZySk2TyklFjwBGsQ1UTSLN5jLyNspRDLrPXeu
	6snmEC97t3xquweF8CpTGCvd6UZtnAPo2H+4oHlvsoHIF2bOcCVa10mISuiUtf9nT5GQZj6Qsfj
	9551N3nUvZwPTR+CQg==
X-Google-Smtp-Source: AGHT+IFXO0bc98TILisSLWFo9DMtGHe+NJnAu+3bVoZrVskI5Vwj+5fj8+osdoMG6pvRImmQlCvYfA==
X-Received: by 2002:a05:6402:4494:b0:5de:4acc:8a97 with SMTP id 4fb4d7f45d1cf-5dec9e791dbmr6368709a12.8.1739533035167;
        Fri, 14 Feb 2025 03:37:15 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1c4692sm2773062a12.31.2025.02.14.03.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 03:37:14 -0800 (PST)
Date: Fri, 14 Feb 2025 12:37:13 +0100
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: Find root of the stall: was: Re: [PATCH 2/3] livepatch: Avoid
 blocking tasklist_lock too long
Message-ID: <Z68q6TfUGpsmkHUD@pathway.suse.cz>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <Z63VUsiaPsEjS9SR@pathway.suse.cz>
 <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>
 <CALOAHbD+JYnC0fR=BaUvD9u0OitHM310ErzN8acPkFZZwH-dJQ@mail.gmail.com>
 <CALOAHbB46k0kqaH8BZk+iyL46bMbz03Z8sk7N+XuYM3kthTsNw@mail.gmail.com>
 <20250214083603.53roteiobbd5s4de@jpoimboe>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214083603.53roteiobbd5s4de@jpoimboe>

On Fri 2025-02-14 00:36:03, Josh Poimboeuf wrote:
> On Fri, Feb 14, 2025 at 10:44:59AM +0800, Yafang Shao wrote:
> > The longest duration of klp_try_complete_transition() ranges from 8.5
> > to 17.2 seconds.
> > 
> > It appears that the RCU stall is not only driven by num_processes *
> > average_klp_try_switch_task, but also by contention within
> > klp_try_complete_transition(), particularly around the tasklist_lock.
> > Interestingly, even after replacing "read_lock(&tasklist_lock)" with
> > "rcu_read_lock()", the RCU stall persists. My verification shows that
> > the only way to prevent the stall is by checking need_resched() during
> > each iteration of the loop.
> 
> I'm confused... rcu_read_lock() shouldn't cause any contention, right?
> So if klp_try_switch_task() isn't the problem, then what is?

I agree that it does not make much sense.

> I wonder if those function timings might be misleading.  If
> klp_try_complete_transition() gets preempted immediately when it
> releases the lock, it could take a while before it eventually returns.
> So that funclatency might not be telling the whole story.

The scheduling might be an explanation.

> Though 8.5 - 17.2 seconds is a bit excessive...

If klp_try_complete_transition() scheduled out and we see this delay
then the system likely had a pretty high load at the moment.
Is it possible?

Yafang, just to be sure. Have you seen these numbers with
the original klp_try_complete_transition() code and with debug
messages disabled?

Or did you saw them with some extra debugging code or other
modifications?

Also just to be sure. Is this on bare metal?

Finally, what preemption mode are you using? Which CONFIG_PREEMPT*?

Best regards,
Petr

PS: JFYI, I have vacation the following week and won't have
    access to mails...

