Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7890428E893
	for <lists+live-patching@lfdr.de>; Wed, 14 Oct 2020 23:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgJNVx1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Oct 2020 17:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgJNVx1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Oct 2020 17:53:27 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AED1E21D81;
        Wed, 14 Oct 2020 21:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602712407;
        bh=unxNc/dC6O+tH6k+cAVjKqEB/qHLKjUAq44H/HJFcxg=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=NsseFkcnMxzgatfa0JyCZmW7laFl7xeL/xIz8uzgNlcLjBGQuMR+Y5mwvii8ZTNsY
         TkYbcjId3fhwk94WQMOQZAiT6dNU3hIYNxyaQSRvAxHz1D+IgIrDTkgX0NclumSkN5
         PTD19AIm5L2dWWxKrr8IeRPGd0yUwfu8D8DsYbTw=
Date:   Wed, 14 Oct 2020 23:53:13 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        pmladek@suse.com, shuah@kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] selftests/livepatch: Do not check order when using "comm"
 for dmesg checking
In-Reply-To: <bd7b15d6-1796-9fb4-bf52-14bcd981458d@redhat.com>
Message-ID: <nycvar.YFH.7.76.2010142352470.18859@cbobk.fhfr.pm>
References: <20200827110709.26824-1-mbenes@suse.cz> <20200827132058.GA24622@redhat.com> <nycvar.YFH.7.76.2008271528000.27422@cbobk.fhfr.pm> <bd7b15d6-1796-9fb4-bf52-14bcd981458d@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 14 Oct 2020, Joe Lawrence wrote:

> >> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> >>
> >> And not so important for selftests, but helpful for backporting efforts:
> >>
> >> Fixes: 2f3f651f3756 ("selftests/livepatch: Use "comm" instead of "diff" for
> >> dmesg")
> > 
> > I've added the Fixes: tag and applied to for-5.9/upstream-fixes. Thanks,
> > 
> 
> Hi Jiri,
> 
> I was looking at a list of livepatching commits that went into 5.9 for
> backporting and was wondering if we ever merged this one?
> 
> It's not a show-stopper, but would be nice to get this one in for 5.10 if
> possible.

Hi Joe,

it was not enough of a trigger to actually send 5.9-rc pull request. But 
in cases like this, for-5.x/upstream-fixes branch gets included in 5.x+1 
pull request. So it absolutely will land in 5.10.

Thanks,

-- 
Jiri Kosina
SUSE Labs

