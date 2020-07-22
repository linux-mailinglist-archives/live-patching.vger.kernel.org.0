Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61647229F33
	for <lists+live-patching@lfdr.de>; Wed, 22 Jul 2020 20:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGVSZE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jul 2020 14:25:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:23523 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgGVSZE (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jul 2020 14:25:04 -0400
IronPort-SDR: 0Q8LwTn3V6mJQwhUeF0vHnMOteUFPyhiOq7qYPd5h7WiwiyH+gIkZPvGVoIRJIu8V6FilyvUhX
 w+03zLBuxVow==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="215029140"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="215029140"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 11:25:03 -0700
IronPort-SDR: 0aKlQxXbmxsipBjsWOtrkvAy7O06GfhEqxJVOlVaisFefFtYFu31rglF+d2fWnFGv7uefTvaVh
 x0s8xDK0OrAA==
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284311422"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.14.158])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 11:24:59 -0700
Message-ID: <24fedc0f503527ef847a4f534277856388fb6a6a.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
Date:   Wed, 22 Jul 2020 11:24:46 -0700
In-Reply-To: <b5bc7a92-a11e-d75d-eefb-fc640c87490d@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
         <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
         <202007220738.72F26D2480@keescook>
         <aa51eb26-e2a9-c448-a3b8-e9e68deeb468@redhat.com>
         <b5bc7a92-a11e-d75d-eefb-fc640c87490d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 2020-07-22 at 10:56 -0400, Joe Lawrence wrote:
> On 7/22/20 10:51 AM, Joe Lawrence wrote:
> > On 7/22/20 10:39 AM, Kees Cook wrote:
> > > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > > > Let me CC live-patching ML, because from a quick glance this is
> > > > something
> > > > which could impact live patching code. At least it invalidates
> > > > assumptions
> > > > which "sympos" is based on.
> > > 
> > > In a quick skim, it looks like the symbol resolution is using
> > > kallsyms_on_each_symbol(), so I think this is safe? What's a good
> > > selftest for live-patching?
> > > 
> > 
> > Hi Kees,
> > 
> > I don't think any of the in-tree tests currently exercise the
> > kallsyms/sympos end of livepatching.
> > 
> 
> On second thought, I mispoke.. The general livepatch code does use
> it:
> 
> klp_init_object
>    klp_init_object_loaded
>      klp_find_object_symbol
> 
> in which case any of the current kselftests should exercise that.
> 
>    % make -C tools/testing/selftests/livepatch run_tests
> 
> -- Joe
> 

Thanks, it looks like this should work for helping me exercise the live
patch code paths. I will take a look and get back to you all.

