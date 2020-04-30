Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDFF1BF6EC
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2020 13:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgD3Lf7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Apr 2020 07:35:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:36736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgD3Lf7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Apr 2020 07:35:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0E6E1ACB1;
        Thu, 30 Apr 2020 11:35:57 +0000 (UTC)
Date:   Thu, 30 Apr 2020 13:35:57 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jessica Yu <jeyu@kernel.org>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v4 11/11] module: Make module_enable_ro() static again
In-Reply-To: <20200430111032.GA4436@linux-8ccs>
Message-ID: <alpine.LSU.2.21.2004301334560.8465@pobox.suse.cz>
References: <cover.1588173720.git.jpoimboe@redhat.com> <d8b705c20aee017bf9a694c0462a353d6a9f9001.1588173720.git.jpoimboe@redhat.com> <20200430111032.GA4436@linux-8ccs>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 30 Apr 2020, Jessica Yu wrote:

> +++ Josh Poimboeuf [29/04/20 10:24 -0500]:
> >Now that module_enable_ro() has no more external users, make it static
> >again.
> >
> >Suggested-by: Jessica Yu <jeyu@kernel.org>
> >Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> 
> Thanks! Since this patch is separate from the rest and it's based on
> modules-next, I can just take this last patch through the modules tree.

It depends on 8/11 of the series.

Acked-by: Miroslav Benes <mbenes@suse.cz>

for the patch.

M
