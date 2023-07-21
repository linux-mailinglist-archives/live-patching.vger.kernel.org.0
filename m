Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A456475BBE1
	for <lists+live-patching@lfdr.de>; Fri, 21 Jul 2023 03:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjGUBkO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jul 2023 21:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjGUBkN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jul 2023 21:40:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94691FED;
        Thu, 20 Jul 2023 18:40:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMV1c001984;
        Fri, 21 Jul 2023 01:39:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2023-03-30;
 bh=BZtX119c1YAIW4RFyhUCK+LylpeHQwScyIa+t9kt638=;
 b=Ic87I25sg9XBPQmhQWzwVBvT2W32kjiLfCI+Nh+KBGq+nmiDlPqrSXw4eA2N95h3AVY1
 V2MJzLBD1kjfHfLu7+OybiDl/u+XPaRcfgvhFJHmq0MV/Tvb9910uWc1Zb8TYnbjyq2N
 lytLuAz33MwVVgQkc69qK+ARDLr0Tc+MKxvdzHa9Qq1w01XJscNX19naOj1einDqNPdP
 FZ31ncrV78JR8R7jIdRpuEcNVv9v3odwFEzBWlOJOF+xzLQszfCP7A8Ecz6UwQwlcgsy
 hbId5HXdezZB6CHnnbmLqj6XEb6YvD4kw90LRI92IeEFdqlxxX8k2iDvTj7ndZs6RErs gQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run7731an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 01:39:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36KN7Prx019211;
        Fri, 21 Jul 2023 01:39:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9vyr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 21 Jul 2023 01:39:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36L1dwwc040835;
        Fri, 21 Jul 2023 01:39:58 GMT
Received: from oracle.com (dhcp-10-154-141-208.vpn.oracle.com [10.154.141.208])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9vyq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 21 Jul 2023 01:39:57 +0000
Date:   Thu, 20 Jul 2023 21:39:54 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Nick Alcock <nick.alcock@oracle.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alessandro Carminati <alessandro.carminati@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        eugene.loh@oracle.com, kris.van.hees@oracle.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Message-ID: <ZLnh3bxQCRZ7564w@oracle.com>
References: <ZLVxUQiC5iF+xTPQ@bombadil.infradead.org>
 <20230714150326.1152359-1-alessandro.carminati@gmail.com>
 <20230717105240.3d986331@gandalf.local.home>
 <874jm088ah.fsf@esperi.org.uk>
 <6edbfe7b-aec4-2b3c-2f85-42e418ab3d99@intel.com>
 <87wmyu7n5t.fsf@esperi.org.uk>
 <20230721100931.b366ecfbeb09cba01c73d47a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721100931.b366ecfbeb09cba01c73d47a@kernel.org>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-20_12,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210014
X-Proofpoint-GUID: foimvApiqjguQfiOtuStkh9xqDh9tkq-
X-Proofpoint-ORIG-GUID: foimvApiqjguQfiOtuStkh9xqDh9tkq-
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jul 21, 2023 at 10:09:31AM +0900, Masami Hiramatsu wrote:
> On Thu, 20 Jul 2023 14:00:46 +0100
> Nick Alcock <nick.alcock@oracle.com> wrote:
> 
> > On 19 Jul 2023, Alexander Lobakin verbalised:
> > 
> > > From: Nick Alcock <nick.alcock@oracle.com>
> > > Date: Wed, 19 Jul 2023 12:12:06 +0100
> > >>> Yes, please coordinate with Nick and review each other's work, now we
> > >>> have two separate efforts with different reasons but hopefully we'll
> > >
> > > Three efforts[0] :D Mine went unnoticed unfortunately, so I switched to
> > > other projects then.
> > 
> > It's odd, nobody seems to have noticed these until recently and now
> > suddenly people are crawling out of the woodwork wanting unique
> > addresses :) maybe the ambiguous ones are just getting commonplace
> > enough that they're biting people more often?
> 
> Usually, the ambiguous symbols are used as internal functions and
> are easily changed by kernel update. Thus it is only used for debugging.
> On the other hand, exposed symbols are considered as more stable (It's
> not really that stable.) so users tend to use that.

In the use case of DTrace, tracing internal functions is certainly something
that is used, be it for debugging/performance analysis, for gaining better
understanding what internal operations are triggerd by userspace actions, etc.

> BTW, note that `perf probe` and kprobe-events already supported that by
> '_text+OFFSET' style to point those functions (`perf probe` convert the
> given 'function@file-path' place to '_text+OFFSET' using DWARF and ELF).
> BPF doesn't because it only supports "function name". (I'm not sure how
> Dtrace support it)

DTrace supports arbitrary address probing based on an offset from a symbol.

> If we really consider to improve BPF trace to trace such internal functions,
> I think you should consider to reuse perf-probe's code to find actual
> address and convert it to '_text+OFFSET' style to specify the probe point.
> 
> I think this still useful if user can identify the traced symbol from the
> source code line, easily without DWARF analysis. And BPF also need to
> support "SYMBOL+OFFSET" style probe points.

While identifying a traced symbol is important, the use cases I am seeing are
the other way around... being able to specify a symbol name (with whatever
additional elements needed to make it unique) as target for placing a probe.
And doing so without needing to depend on DWARF data or other rather large
collection of debug data.  Especially on production systems, requiring the
typically very large debuginfo style data to be installed is not acceptable
for the use cases I encounter.

> > > My idea was to give relative path from the kernel root to the objfile,
> > > as we have a good bunch of non-unique "filename + symbol name" pairs.
> > 
> > I considered that, but unfortunately that has two problems to a raging
> > perfectionist like me:
> > 
> >  - the objfile probably won't exist except if you're actually doing
> >    kernel development, since kernel build trees are big enough that a
> >    lot of people delete them after building or ship kernels to other
> >    machines: if someone else built your kernel (overwhelmingly common
> >    among non-kernel-devs) the objfiles are sure to be absent. (But an
> >    option to not truncate the names when you know they won't be absent
> >    might be a good idea, though this pushes space requirements up by
> >    hundreds of kilobytes so it should probably be off by default.)
> 
> As I said, these internal symbol tracing is usually only for debugging
> the kernel. So I think this is not so problematic.
> 
> Thank you,
> 
> > 
> >  - even giving a path to the kernel module on disk (much lower
> >    resolution and vulnerable to ambiguity again) is unreliable because
> >    there's absolutely no guarantee that any given process can see any of
> >    them: they might be in a different fs namespace or the modules might
> >    only be present in an initramfs (hell, I even know setups which
> >    *compile* the modules needed for rootfs mounting in the initramfs!
> >    Yes this is borderline insane, yes it happens). More commonly, they
> >    might be compressed using any of a number of compressors, changing
> >    the name, and the kernel has no idea which compressor might have been
> >    used (not unless you want it to go and look, and, well, wandering
> >    around over the fs hunting down .ko.* files from kernelspace to get
> >    their names right is *not* my idea of a good time! It's hard enough
> >    to get that right from userspace, honestly, even with kmod helping.)
> > 
> >    The most you could do would be to provide a key you could use with
> >    kmod to dig the real modules out from userspace. Partial names are as
> >    good as anything for that :)
> > 
> > So all the objfile names are, when it comes down to it, is names with no
> > intrinsic meaning: even if they're filenames of some kind, tools can't
> > rely on being able to access those files. (For my most common use case,
> > using a tracer on an enterprise-built production kernel, they'd almost
> > never be able to.)
> > 
> > So you might as well treat the objfile names as arbitrary string keys
> > that might be a memory-jogger for humans, which means you can chop
> > boring bits off them to save space :)
> 
> 
> -- 
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
