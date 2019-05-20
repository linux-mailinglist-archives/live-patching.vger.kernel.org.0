Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D822431B
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2019 23:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfETVsD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 May 2019 17:48:03 -0400
Received: from out.bound.email ([141.193.244.10]:42377 "EHLO out.bound.email"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfETVsD (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 May 2019 17:48:03 -0400
Received: from mail.sventech.com (localhost [127.0.0.1])
        by out.bound.email (Postfix) with ESMTP id 2CF5D8A0E7F;
        Mon, 20 May 2019 14:48:02 -0700 (PDT)
Received: by mail.sventech.com (Postfix, from userid 1000)
        id 12C181600410; Mon, 20 May 2019 14:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=erdfelt.com;
        s=default; t=1558388882;
        bh=hXSuV/KWcIjYiQTMffAlTRJmVWRSIOLEh2gjHl+ssZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0aHVATGEq3IMupDFMnxubXV08UoTZ2ZOH6DC+mM1OoXKOpaFd+V9XZW8um1kNjAn
         iauu4bo/sJUjqvgNGA1xQva7T31Fv+1WceN5PUg3sxcN7MvkvHHBieXRF+jx6+8RK4
         TpTcd0/SXFC9a4g5bJ3gqk1oEw3v17B3QOmDyxqg=
Date:   Mon, 20 May 2019 14:48:02 -0700
From:   Johannes Erdfelt <johannes@erdfelt.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190520214801.GD1646@sventech.com>
References: <20190520194915.GB1646@sventech.com>
 <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
 <20190520210905.GC1646@sventech.com>
 <20190520211931.vokbqxkx5kb6k2bz@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520211931.vokbqxkx5kb6k2bz@treble>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 20, 2019, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> I think you must have been looking at an old version.
> 
> [(v5.2-rc1)] ~/git/linux $ grep jeyu MAINTAINERS
> M:	Jessica Yu <jeyu@kernel.org>

Operator error on my part. I was looking at a different directory with
an old branch checked out. Sorry!

> Can you try this patch (completely untested)?

It seems to be working fine for me. No crashes in a loop for a few
minutes, when it would usually only take a couple of tries to reproduce
the issue for me.

I'll see if I can better reproduce the race from the ftrace side since
every crash I have seen for this issue has been in apply_relocate_add
on the livepatch side.

JE

