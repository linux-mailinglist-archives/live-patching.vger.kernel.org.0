Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35622240AFF
	for <lists+live-patching@lfdr.de>; Mon, 10 Aug 2020 18:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgHJQKs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Aug 2020 12:10:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:41566 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgHJQKr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Aug 2020 12:10:47 -0400
IronPort-SDR: E0f4ZdAjswR6z5/J+pv3qsv4XXWZ5bBHrCcW7YMm462uiDzVbp5SggIDPXqP/H4Q6wLIZ6LU4k
 gBvapLZxjYNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="141420194"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="141420194"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 09:10:46 -0700
IronPort-SDR: L0fGK7Oc41XXt/uCpVijKONSkPdWYSy53uICatG+sIVZajt8GK0hK7Me29p68sdmSoSBzhgOHo
 z8ekofBUjVhg==
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="494847826"
Received: from unknown (HELO kcaccard-mobl1.jf.intel.com) ([10.251.4.141])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 09:10:44 -0700
Message-ID: <6b96dcb30b9e1ab1638979c09462614aa2976721.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org
Date:   Mon, 10 Aug 2020 09:10:41 -0700
In-Reply-To: <202008071019.BF206AE8BD@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
         <20200804182359.GA23533@redhat.com>
         <f8963aab93243bc046791dba6af5d006e15c91ff.camel@linux.intel.com>
         <202008071019.BF206AE8BD@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 2020-08-07 at 10:20 -0700, Kees Cook wrote:
> On Fri, Aug 07, 2020 at 09:38:11AM -0700, Kristen Carlson Accardi
> wrote:
> > Thanks for testing. Yes, Josh and I have been discussing the
> > orc_unwind
> > issues. I've root caused one issue already, in that objtool places
> > an
> > orc_unwind_ip address just outside the section, so my algorithm
> > fails
> > to relocate this address. There are other issues as well that I
> > still
> > haven't root caused. I'll be addressing this in v5 and plan to have
> > something that passes livepatch testing with that version.
> 
> FWIW, I'm okay with seeing fgkaslr be developed progressively.
> Getting
> it working with !livepatching would be fine as a first step. There's
> value in getting the general behavior landed, and then continuing to
> improve it.
> 

In this case, part of the issue with livepatching appears to be a more
general issue with objtool and how it creates the orc unwind entries
when you have >64K sections. So livepatching is a good test case for
making sure that the orc tables are actually correct. However, the
other issue with livepatching (the duplicate symbols), might be worth
deferring if the solution is complex - I will keep that in mind as I
look at it more closely.


