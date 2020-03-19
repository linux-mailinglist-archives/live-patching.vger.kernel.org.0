Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B3A18B1A3
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2020 11:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCSKih (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Mar 2020 06:38:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:60682 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCSKih (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Mar 2020 06:38:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 94E11B1D1;
        Thu, 19 Mar 2020 10:38:35 +0000 (UTC)
Date:   Thu, 19 Mar 2020 11:38:34 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jan Beulich <jbeulich@suse.com>
cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com,
        andrew.cooper3@citrix.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        xen-devel@lists.xenproject.org, jslaby@suse.cz
Subject: Re: [PATCH v2 2/2] x86/xen: Make the secondary CPU idle tasks
 reliable
In-Reply-To: <2ca0a03c-734c-3a9e-90fd-8209046c5f01@suse.com>
Message-ID: <alpine.LSU.2.21.2003191131280.24428@pobox.suse.cz>
References: <20200319095606.23627-1-mbenes@suse.cz> <20200319095606.23627-3-mbenes@suse.cz> <2ca0a03c-734c-3a9e-90fd-8209046c5f01@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 19 Mar 2020, Jan Beulich wrote:

> On 19.03.2020 10:56, Miroslav Benes wrote:
> > --- a/arch/x86/xen/smp_pv.c
> > +++ b/arch/x86/xen/smp_pv.c
> > @@ -53,6 +53,7 @@ static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
> >  static DEFINE_PER_CPU(struct xen_common_irq, xen_pmu_irq) = { .irq = -1 };
> >  
> >  static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id);
> > +extern unsigned char asm_cpu_bringup_and_idle[];
> 
> Imo this would better reflect the actual type, i.e. be a function
> decl. If left as an array one, I guess you may want to add const.

I sticked to what x86 has for secondary_startup_64. I can make it

void asm_cpu_bringup_and_idle(void);

Miroslav
