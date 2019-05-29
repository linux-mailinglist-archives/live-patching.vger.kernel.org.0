Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A882D2DC6D
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2019 14:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfE2MGw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 May 2019 08:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbfE2MGw (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 May 2019 08:06:52 -0400
Received: from oasis.local.home (unknown [12.156.218.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D455120644;
        Wed, 29 May 2019 12:06:50 +0000 (UTC)
Date:   Wed, 29 May 2019 08:06:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190529080648.0e001bfd@oasis.local.home>
In-Reply-To: <nycvar.YFH.7.76.1905291315310.1962@cbobk.fhfr.pm>
References: <20190520194915.GB1646@sventech.com>
        <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
        <20190520210905.GC1646@sventech.com>
        <20190520211931.vokbqxkx5kb6k2bz@treble>
        <20190520173910.6da9ddaf@gandalf.local.home>
        <20190521141629.bmk5onsaab26qoaw@treble>
        <20190521104204.47d4e175@gandalf.local.home>
        <20190521164227.bxdff77kq7fgl5lp@treble>
        <20190521125319.04ac8b6c@gandalf.local.home>
        <nycvar.YFH.7.76.1905291315310.1962@cbobk.fhfr.pm>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 29 May 2019 13:17:21 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> wrote:

> > > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Subject: [PATCH] livepatch: Fix ftrace module text permissions race  
> > 
> > Thanks,
> > 
> > I'll try to find some time to test this as well.  
> 
> Steve, Jessica, any final word on this?

I was under the impression that Josh was going to send an updated
patch (and a properly sent one). Patches embedded in other emails don't
get flagged by my internal patchwork, so they usually get ignored.

-- Steve
