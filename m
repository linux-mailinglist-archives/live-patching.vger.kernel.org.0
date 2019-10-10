Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395DCD2B80
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2019 15:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbfJJNit (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Oct 2019 09:38:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:55212 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728393AbfJJNit (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Oct 2019 09:38:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B178DAEB3;
        Thu, 10 Oct 2019 13:38:47 +0000 (UTC)
Date:   Thu, 10 Oct 2019 15:38:20 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>, jpoimboe@redhat.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] ftrace: Introduce PERMANENT ftrace_ops flag
In-Reply-To: <20191010091403.5ecf0fdb@gandalf.local.home>
Message-ID: <alpine.LSU.2.21.1910101535310.32665@pobox.suse.cz>
References: <20191007081714.20259-1-mbenes@suse.cz> <20191008193534.GA16675@redhat.com> <20191009112234.bi7lvp4pvmna26vz@pathway.suse.cz> <20191009102654.501ad7c3@gandalf.local.home> <20191010085035.emsdks6xecazqc6k@pathway.suse.cz>
 <20191010091403.5ecf0fdb@gandalf.local.home>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 10 Oct 2019, Steven Rostedt wrote:

> On Thu, 10 Oct 2019 10:50:35 +0200
> Petr Mladek <pmladek@suse.com> wrote:
> 
> > It will make the flag unusable for other ftrace users. But it
> > will be already be the case when it can't be disabled.
> 
> Honestly, I hate that flag. Most people don't even know about it. It
> was added in the beginning of ftrace as a way to stop function tracing
> in the latency tracer. But that use case has been obsoleted by
> 328df4759c03e ("tracing: Add function-trace option to disable function
> tracing of latency tracers"). I may just remove the damn thing and only
> add it back if somebody complains about it.

That would of course solve the issue too and code removal is always 
better.

Miroslav
