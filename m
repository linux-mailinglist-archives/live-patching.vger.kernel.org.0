Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC505333726
	for <lists+live-patching@lfdr.de>; Wed, 10 Mar 2021 09:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCJISO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 Mar 2021 03:18:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:58982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhCJISI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 Mar 2021 03:18:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D3C81AC1F;
        Wed, 10 Mar 2021 08:18:06 +0000 (UTC)
Date:   Wed, 10 Mar 2021 09:18:06 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jinyang He <hejinyang@loongson.cn>
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Xuefeng Li <lixuefeng@loongson.cn>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH RFC] MIPS: livepatch: Add LIVEPATCH basic code
In-Reply-To: <1614598201-17858-1-git-send-email-hejinyang@loongson.cn>
Message-ID: <alpine.LSU.2.21.2103100912590.13355@pobox.suse.cz>
References: <1614598201-17858-1-git-send-email-hejinyang@loongson.cn>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

I cannot really comment on mips arch specifics but few words from the live 
patching perspective.

On Mon, 1 Mar 2021, Jinyang He wrote:

> Add the basic code of livepatch. livepatch is temporarily unavailable.
> Two core functions are missing, one is DYNAMIC_FTRACE_WITH_REGS, and
> another is save_stack_trace_tsk_reliable().
> `Huang Pei <huangpei@loongson.cn>` is doing for ftrace. He will use
> `-fpatchable-function-entry` to achieve more complete ftrace.

DYNAMIC_FTRACE_WITH_ARGS has been introduced recently, so you might also 
look at that. As far as the live patching is concerned, 
DYNAMIC_FTRACE_WITH_ARGS is sufficient.

> save_stack_trace_tsk_reliable() currently has difficulties. This function
> may be improved in the future, but that seems to be a long time away.
> This is also the reason for delivering this RFC. Hope to get any help.

You may want to look at Documentation/livepatch/reliable-stacktrace.rst 
which nicely describes the requirements for the reliable stacktraces. 

Regards
Miroslav
