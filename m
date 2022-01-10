Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28A0489BA9
	for <lists+live-patching@lfdr.de>; Mon, 10 Jan 2022 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiAJO4C (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Jan 2022 09:56:02 -0500
Received: from mail-qk1-f171.google.com ([209.85.222.171]:43629 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235769AbiAJO4B (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Jan 2022 09:56:01 -0500
Received: by mail-qk1-f171.google.com with SMTP id f138so15013948qke.10;
        Mon, 10 Jan 2022 06:56:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L3beBrNOg3nuBaTtpl+UOIFPH3z+4rFJ8EtzyRQDCqA=;
        b=ESGJHrpZKFlpLalyjhF0qxU8uMwK+CMumj+W/8VNxFkWjwwIdVhP7CDkMPCGqCZHYo
         IWJ8qGruQLF05ZMdhGHZvN8Dn9iHjC/sygI9Gj6I0g0B969wOweUX2AZlub8/PDxNvFw
         irieMbHtG72W975ks5VZ5wimmNTnIE6f4AIO0G++sOPDhCEXoDgacDZdU4tIpBUfLSoi
         Od5r/qrQDxx5gWBpRglFOF379d/h2pY3lyahER5pvWBUQMZBNnUfpTRze4WMjO6BIOU4
         DZYk7cMTiqO81Bvr7Tmq5Dnq68RTmqzvscLk45qFjAKiocdO3u6uQvwQ7IRxBKTmxMq1
         RDOQ==
X-Gm-Message-State: AOAM5329MYfDDkB9LsnKFlHM5XRTod5zYlVnZjBUv+gbBltl+f8rbaDA
        Kr7gYlQRp2thdI++KW85Zoo=
X-Google-Smtp-Source: ABdhPJzFvAsCF2kXeHrEyboneBZ+Y7lG9bomaFt7c9MDvgK0pQVBWw08I+MccZhaYxYjK9wgpsUe3w==
X-Received: by 2002:a05:620a:1a08:: with SMTP id bk8mr11861qkb.195.1641826560971;
        Mon, 10 Jan 2022 06:56:00 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-011.fbsv.net. [2a03:2880:20ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id v12sm4835415qtx.80.2022.01.10.06.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 06:56:00 -0800 (PST)
Date:   Mon, 10 Jan 2022 06:55:59 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Message-ID: <YdxI/xFf1btdIhLl@dev0025.ash9.facebook.com>
References: <20211229215646.830451-1-void@manifault.com>
 <CAPhsuW5PL1w_72Hrbsp2b3jA-SGyzv5oLfgybkq=s8J5KL6kmw@mail.gmail.com>
 <Ydf3MBet/B+lUdRv@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ydf3MBet/B+lUdRv@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> wrote on Fri [2022-Jan-07 09:17:52 +0100]:
> On Thu 2022-01-06 16:21:18, Song Liu wrote:
> > PS: Do we observe livepatch takes a longer time to load after this change?
> > (I believe longer time shouldn't be a problem at all. Just curious.)
> 
> It should depend on the load of the system and the number of patched
> symbols. The module is typically loaded with a normal priority
> process.
> 
> The commit message talks about 1.3 seconds delay of ksoftirq. In
> principle, the change caused that this 1.3 sec of a single CPU time
> was interleaved with other scheduled tasks on the same CPU. I would
> expect that it prolonged the load just by a couple of seconds in
> the described use case.

Just to add a data point here for the record, I didn't observe any increase
in latency when applying a livepatch with this change. It took roughly ~2
+/- ~.5 seconds both with and without the change. Obviously that number
doesn't mean much without knowing the specifics of the patch and what
workloads were running on the host, but in general the invocations to
cond_resched() patch did not seem to materially affect the overhead of
livepatching.

The only time I would expect it to cause longer livepatches is when there
are a lot of tasks that need the CPU, which is dependent on system load as
Petr said. I'd argue that in this case, the patch would be working as
intended as hogging the CPU for 1 or more seconds seems like a recipe for
problems.
