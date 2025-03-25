Return-Path: <live-patching+bounces-1329-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 237FEA701D2
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 14:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53B508438CF
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 13:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9A8263C77;
	Tue, 25 Mar 2025 12:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RBKlppRh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04DD1DF72C
	for <live-patching@vger.kernel.org>; Tue, 25 Mar 2025 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906780; cv=none; b=Y9d4Ymd5H+skGDePYrwV4un5r/C7uNqLeHU42lZsJa2SoGA4wIQQxe8maJE6sC2AotvFbrJMfEHa8OnJoA5wp/qJZ+8Mrb2HmR12bTMXgDZjlbGxWrKavF27vg+BIU5EIACo/+ywcQ8s7CGTL4bU+rQvBDuieWEy6SqLgzieO+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906780; c=relaxed/simple;
	bh=21cSZlgkzkeUOKjTRkIqssBxNCbNL54vjqaRL5lDIk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I79I0mUpOnP4Z7nt+mHgFw9ppX0bGgsHNtaU7YxWHgzWWGnWnq7WqMUwPf8z9AiBgKdsTN/1gSGFNAe0CSGQGHPvEnHGVISvg/1KDcICJs8fUjR5mPzHzAv+4l+XBe/wdsKZk8rldKGYh537daHmi4zxuf57v+8QyjrazdLhUiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RBKlppRh; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43d2d952eb1so41608845e9.1
        for <live-patching@vger.kernel.org>; Tue, 25 Mar 2025 05:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742906777; x=1743511577; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=By6GKEF0/TQDMKwWtmL5qjHgFGIdgMAM69SNagaKUec=;
        b=RBKlppRhywaAbfsRIvOEIRIDvj9ILQSXAIhO5YLhZhPhNp/ZbhmvQXhYSIIY5kmIgB
         Xz88fKpet5CnfZOgqeDO3d2gbiWGx7uIe53k9EwVtLtbyWL0YbBX6jFksSxAdfVkTR3z
         RYjhV2DjiACZwIzKh4TcnaSttaneP1+oLH9mMuxhMeecd2zmf195q7zWYkHZnVc2YHO5
         zavJBs2Db1hehAmuCHuQgThTwArz53HfTPU+na6cWE/KXxSIYx7L1lKYkDB79Up+lR1w
         KvHQB6WtAC23jOD+JOeU37EBWJTT0yPU4YMN/b3+PjZYKqdh0kDExbk/g+bCCALSIeW7
         8XoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742906777; x=1743511577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=By6GKEF0/TQDMKwWtmL5qjHgFGIdgMAM69SNagaKUec=;
        b=lQMfswdbt9rqHvk1W58hHzgQiSOyd9tXMOUkGzxTzBFnDors+Cs4NHqqRN94Cj84oI
         vUcaS0Jkbtn7jiwwfTnrF60VnLWdpKPnHXCRI3IqoVFWUCN9goZgzGE96fLdglnQ//SY
         JSdCMO+ie4ox92g4Icki0aTw2zUHcy1G18Pzsgl2J1IMd+ocKydeZqa2zNmuPmCdqh7c
         tS1zNIcDhwpsMno+AmnMfdsWJwQZC7l1Vu7Lx1+AqDV9Fqw0J5g/n1MGIzopAObY5voK
         tfN7nNrv6+RHAxpyna3kylzmMMk2XYmbdofM9vfcNIhSw+tpSe8La8W8Bqc6P2JLU85e
         x62A==
X-Gm-Message-State: AOJu0YwPS/A5Xi2reqcXOyoVm/gOemWesEvEhnRWEKpATq+MMny+Nq0m
	Hcanh3em/K1mYYw0YhdEYY4HRP8hJhk/YWkZRlmHFY6Eh8tc4mP0hgzka2qMi+Ly9q/na3zWBa9
	z
X-Gm-Gg: ASbGncvdD2ARyZfZdTKSbpw9uvEpXABm0ZleRIbfE96KL75b/l2hy+R82kiUcchZRB/
	NfLRirETSOcAr5EUrko1ElabhHpXG8YUK4sqSk0T656jqvPPogSDyMpZIGg8DfQTmAXRlXi+BED
	3qgTHyn8tVBfRtoErxVs4x17rASwnv1r0qupB7untpFMMlOljiFMaMnpGSZPmWC86E8fieeMZ/h
	3mLZLpmSONGnwF7Cl+bD7oDLOrAgRlVx0nf+ghahMGcldDGsA3uLZBRiYDXnYRbKVYcw4yBu/1/
	PGu7o3b+WMvQwUAxIuyjYNdiSDEE0tPpEV4hegsVkvmc
X-Google-Smtp-Source: AGHT+IGNxUPBJch+nZI8b31cwZsp6Hfb+xKQ99A61fBsuSDMC9cTNsDlmDlNtsSeoSSN4sYpGnZwYQ==
X-Received: by 2002:a05:600c:3ca5:b0:43c:fceb:91a with SMTP id 5b1f17b1804b1-43d509ec5a9mr175175905e9.11.1742906777055;
        Tue, 25 Mar 2025 05:46:17 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43fdec51sm202041345e9.27.2025.03.25.05.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 05:46:16 -0700 (PDT)
Date: Tue, 25 Mar 2025 13:46:14 +0100
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	jpoimboe@kernel.org, kernel-team@meta.com, jikos@kernel.org,
	mbenes@suse.cz
Subject: Re: [PATCH v2] selftest/livepatch: Only run test-kprobe with
 CONFIG_KPROBES_ON_FTRACE
Message-ID: <Z-KlltGNZoL2cC6F@pathway.suse.cz>
References: <20250318181518.1055532-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318181518.1055532-1-song@kernel.org>

On Tue 2025-03-18 11:15:18, Song Liu wrote:
> CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
> when CONFIG_KPROBES_ON_FTRACE is not set. Since some kernel may not have
> /proc/config.gz, grep for kprobe_ftrace_ops from /proc/kallsyms to check
> whether CONFIG_KPROBES_ON_FTRACE is enabled.
> 
> Signed-off-by: Song Liu <song@kernel.org>

JFYI, I have added the -q option and pushed the patch into
livepatching.git, branch for-6.15/trivial, see
https://web.git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/commit/?h=for-6.15/trivial

IMHO, it is trivial and it is a selftest so it still go into 6.15.
I am going to send the pull request on Thursday or so.

Best Regards,
Petr

